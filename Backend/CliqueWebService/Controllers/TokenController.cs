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
    public class TokenController : ControllerBase
    {
        Database _db;
        BusinessLogic _businessLogic;
        private readonly IConfiguration _configuration;

        public TokenController(IConfiguration configuration)
        {
            _configuration = configuration ?? throw new ArgumentNullException();
            _db = new Database(configuration.GetConnectionString("AzureDatabase"));
            _businessLogic = new BusinessLogic();
        }

        [HttpPost]
        public async Task<IActionResult> UserAuthenticate([FromBody] User userRequested)
        {
            string email = userRequested.email;
            string password = userRequested.password;
            if(email != null && password != null)
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
                    string query = $"SELECT user_id, name, surname, email, gender, hash_password FROM Users WHERE email LIKE '{email}' AND hash_password LIKE '{hash.ToLower()}' ";
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
                        expires: DateTime.UtcNow.AddMinutes(15),
                        signingCredentials: signIn);

                    string insert = $"INSERT INTO Tokens (token, user_id, token_expires) VALUES ('{new JwtSecurityTokenHandler().WriteToken(token)}', {user.user_id}, '{token.ValidTo}')";
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
    }
}