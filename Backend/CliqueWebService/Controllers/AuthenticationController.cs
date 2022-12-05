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
                    string query = $"SELECT user_id, name, surname, email, gender_name, contact_no, birth_data, profile_pic, bio FROM Users LEFT JOIN Gender ON gender_id = gender WHERE email LIKE '{email}' AND hash_password LIKE '{hash.ToLower()}'";
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
                    return BadRequest("Something went wrong");
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
                        expires: DateTime.Now.AddMinutes(60),
                        signingCredentials: signIn);

                    string insert = $"INSERT INTO Tokens (token, user_id, token_expires) VALUES ('{new JwtSecurityTokenHandler().WriteToken(token)}', {user.user_id}, '{token.ValidTo.ToString("yyyy-MM-dd HH:mm:ss")}')";
                    _db.ExecuteNonQuery(insert);
                    _db.Disconnect();
                    return Ok(new { token = new JwtSecurityTokenHandler().WriteToken(token), validTo = token.ValidTo.ToString("yyyy-MM-dd HH:mm:ss") });
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
                    docResponse.Status = "0";
                    return StatusCode(StatusCodes.Status500InternalServerError, docResponse);
                }
                string query = $"INSERT INTO Users(name, surname, email, hash_password) VALUES ('{userForRegistration.Name}', '{userForRegistration.Surname}', " +
                    $"'{userForRegistration.Email}', '{_businessLogic.ConvertToSHA256(userForRegistration.Password)}')";
                _db.BeginTransaction();
                string checkUserQ = $"SELECT COUNT(*) FROM Users WHERE email LIKE '{userForRegistration.Email}'";
                try
                {
                    var reader = _db.ExecuteQuery(checkUserQ);
                    while (reader.Read())
                    {
                        if (reader.GetInt32(0) > 0)
                        {
                            docResponse.Message = "User with this username or password already exists";
                            docResponse.Status = "0";
                            return BadRequest(docResponse);
                        }
                    }
                    reader.Close();
                    _db.ExecuteNonQuery(query);
                    _db.CommitTransaction();
                    docResponse.Message = "User successfully registered";
                    docResponse.Status = "1";
                    return Ok(docResponse);
                }
                catch
                {
                    _db.RollbackTransaction();
                    _db.CommitTransaction();
                    docResponse.Error = "Couldn't register user";
                    docResponse.Status = "0";
                    return StatusCode(StatusCodes.Status500InternalServerError, docResponse);
                }
            }
            else
            {
                docResponse.Errors = ModelState.Values.SelectMany(x => x.Errors).Select(x => x.ErrorMessage);
                docResponse.Status = "0";
                return BadRequest(docResponse);
            }

        }
    }
}
