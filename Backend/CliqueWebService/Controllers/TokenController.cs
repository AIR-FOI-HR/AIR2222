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
        public async Task<IActionResult> UserAuthenticate([FromBody] User user1)
        {
            string email = user1.email;
            string password = user1.password;
            if(email != null && password != password)
            {
                //var user = GetUser(email, password);
                User user = new User();
                user = null;
                try
                {
                    _db.Connect();
                }
                catch (Exception ex)
                {
                    return BadRequest("Connection unsuccesful 1");
                }
                try
                {
                    /*Bazično sha256 kriptiranje */
                    //Byte[] inputBytes = Encoding.UTF8.GetBytes(password);
                    //Byte[] hashedBytes = new SHA256CryptoServiceProvider().ComputeHash(inputBytes);
                    List<User> userList = new List<User>();
                    var hash = _businessLogic.ConvertToSHA256(password);
                    string query = $"SELECT user_id, name, surname, email, gender, hash_password FROM Users WHERE email LIKE '{email}' AND hash_password LIKE '{hash.ToLower()}' ";
                    bool idExists = true;
                    var reader = _db.ExecuteQuery(query);
                    if (!reader.HasRows)
                    {
                        return BadRequest("No rows");
                    }

                    while (reader.Read())
                    {
                        if (reader.GetValue(0) != DBNull.Value)
                        {
                            userList.Add(_businessLogic.GetUsers(reader));
                        }
                    }
                    reader.Close();
                    _db.Disconnect();
                    user = userList[0];
                    } 
                catch (Exception e)
                {
                    return BadRequest(e);
                }
                if (user != null)
                {
                    //create claims details based on the user information
                    var claims = new[] {
                        new Claim(JwtRegisteredClaimNames.Sub, _configuration["Jwt:Subject"]),
                        new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                        new Claim(JwtRegisteredClaimNames.Iat, DateTime.UtcNow.ToString()),
                        new Claim("UserId", user.user_id.ToString()),
                        new Claim("Name", user.name),
                        new Claim("Surname", user.surname),
                        new Claim("Email", user.email)
                    };

                    var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["Jwt:Key"]));
                    var signIn = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
                    var token = new JwtSecurityToken(
                        _configuration["Jwt:Issuer"],
                        _configuration["Jwt:Audience"],
                        claims,
                        expires: DateTime.UtcNow.AddMinutes(10),
                        signingCredentials: signIn);

                    return Ok(new JwtSecurityTokenHandler().WriteToken(token));
                }
                else
                {
                    return BadRequest("Invalid credentials");
                }
            }
            else
            {
                return BadRequest();
            }
        }

        /*[HttpGet("{email}, {password}")]
        public User GetUser(string email, string password)
        {
            User userr = new User();
            userr = null;
            try
            {
                _db.Connect();
            }
            catch (Exception ex)
            {

            }
            try
            {
                /*Bazično sha256 kriptiranje 
                Byte[] inputBytes = Encoding.UTF8.GetBytes(password);
                Byte[] hashedBytes = new SHA256CryptoServiceProvider().ComputeHash(inputBytes);
                List<User> user = new List<User>();
                string query = $"SELECT user_id, name, surname, email, gender, hash_password FROM Users WHERE email = '{email}' AND hash_password = '{hashedBytes}' ";
                bool idExists = true;
                var reader = _db.ExecuteQuery(query);
                if (!reader.HasRows)
                {
                    idExists = false;
                }

                while (reader.Read())
                {
                    if (reader.GetValue(0) != DBNull.Value)
                    {
                        user.Add(_businessLogic.GetUsers(reader));
                    }
                }
                Console.WriteLine("Ima");
                reader.Close();
                _db.Disconnect();
                userr = user[0];
            }
            catch (Exception ex)
            {

            }
            return userr;
        }*/
    }
}