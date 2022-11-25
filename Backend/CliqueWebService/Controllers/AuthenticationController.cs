using Microsoft.AspNetCore.Mvc;
using DataAccess;
using CliqueWebService.Helpers;
using CliqueWebService.Helpers.Models;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Cryptography;
using System.Text;
using System.Security.Claims;

namespace CliqueWebService.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthenticationController : ControllerBase
    {
        Database _db;
        BusinessLogic _businessLogic;
        private readonly IConfiguration _configuration;

        public AuthenticationController(IConfiguration configuration)
        {
            _configuration = configuration ?? throw new ArgumentNullException();
            _db = new Database(configuration.GetConnectionString("AzureDatabase"));
            _businessLogic = new BusinessLogic();
        }

        [HttpPost]
        [Route("LoginUser")]
        public async Task<IActionResult> UserAuthenticate([FromBody] LoginRequest userRequested)
        {
            string email = userRequested.Email;
            string password = userRequested.Password;
            if (ModelState.IsValid)
            {
                try
                {
                    _db.Connect();
                }
                catch (Exception ex)
                {
                    return BadRequest("Could not connect to database");
                }

                User user = new User();
                user = null;
                try

                {
                    List<User> userList = new List<User>();
                    var hash = _businessLogic.ConvertToSHA256(password);
                    string query = $"SELECT user_id, name, surname, email, g.gender_name, contact_no, birth_data, profile_pic FROM Users, Gender as g WHERE email LIKE '{email}' AND hash_password LIKE '{hash.ToLower()}' AND g.gender_id = gender";
                    var reader = _db.ExecuteQuery(query);
                    if (!reader.HasRows)
                    {
                        return BadRequest("User not found");
                    }

                    while (reader.Read())
                    {
                        if (reader.GetValue(0) != DBNull.Value)
                        {
                            userList.Add(_businessLogic.GetUsers(reader));
                        }
                    }
                    reader.Close();

                    user = userList[0];
                }
                catch (Exception e)
                {
                    return BadRequest("Could not connect to database");
                }
                if (user != null)
                {
                    var claims = new[] {
                        new Claim(JwtRegisteredClaimNames.Sub, _configuration["Jwt:Subject"]),
                        new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                        new Claim(JwtRegisteredClaimNames.Iat, DateTime.UtcNow.ToString()),
                        new Claim("UserId", user.user_id.ToString()),
                        new Claim("Email", user.email)
                    };

                    var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["Jwt:Key"]));
                    var signIn = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
                    var token = new JwtSecurityToken(
                        _configuration["Jwt:Issuer"],
                        _configuration["Jwt:Audience"],
                        claims,
                        expires: DateTime.Now.AddMinutes(15),
                        signingCredentials: signIn);

                    string insert = $"INSERT INTO Tokens (token, user_id, token_expires) VALUES ('{new JwtSecurityTokenHandler().WriteToken(token)}', {user.user_id}, '{token.ValidTo.ToString("yyyy-MM-dd HH:mm:ss")}')";
                    _db.ExecuteNonQuery(insert);
                    _db.Disconnect();
                    return Ok(new { token = new JwtSecurityTokenHandler().WriteToken(token), token.ValidTo });
                }
                else
                {
                    _db.Disconnect();
                    return BadRequest("Invalid credentials");
                }
            }
            else
            {
                return BadRequest();
            }
        }

        [HttpPost]
        [Route("RegisterUser")]
        public ActionResult RegisterUser([FromBody] RegisterRequest userForRegistration)
        {
            DocumentResponse docResponse = new DocumentResponse();

            if (ModelState.IsValid)
            {
                try
                {
                    _db.Connect();
                }
                catch (Exception ex)
                {
                    docResponse.Error = ex.Message;
                    docResponse.Status = "500 - Internal Server Error";
                    docResponse.Method = "POST";
                    return StatusCode(StatusCodes.Status500InternalServerError, docResponse);
                }
                string query = $"INSERT INTO Users(name, surname, email, hash_password, contact_no, birth_data, gender) VALUES ('{userForRegistration.Name}', '{userForRegistration.Surname}', " +
                    $"'{userForRegistration.Email}', '{_businessLogic.ConvertToSHA256(userForRegistration.Password)}', '{userForRegistration.ContactNum}', '{userForRegistration.BirthData.ToString("yyyy-MM-dd")}', {userForRegistration.Gender})";
                _db.BeginTransaction();
                try
                {
                    _db.ExecuteNonQuery(query);
                    _db.CommitTransaction();
                    docResponse.Message = "User successfully registered";
                    docResponse.Status = "200 - OK";
                    docResponse.Method = "POST";
                    return Ok(docResponse);
                }
                catch
                {
                    _db.RollbackTransaction();
                    _db.CommitTransaction();
                    docResponse.Error = "Couldn't register user";
                    docResponse.Status = "500 - Internal Server Error";
                    docResponse.Method = "POST";
                    return StatusCode(StatusCodes.Status500InternalServerError, docResponse);
                }
            }
            else
            {
                docResponse.Error = "Incorrectly formated JSON request";
                docResponse.Status = "400 - Bad Request";
                docResponse.Method = "POST";
                return BadRequest(docResponse);
            }

        }
    }
}
