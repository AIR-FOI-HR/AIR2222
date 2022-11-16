using CliqueWebService.Helpers;
using CliqueWebService.Helpers.Models;
using DataAccess;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace CliqueWebService.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RegisterController : ControllerBase
    {
        Database _db;
        BusinessLogic _businessLogic;
        private readonly IConfiguration _configuration;

        public RegisterController(IConfiguration configuration)
        {
            _configuration = configuration ?? throw new ArgumentNullException();
            _db = new Database(configuration.GetConnectionString("AzureDatabase"));
            _businessLogic = new BusinessLogic();
        }
        [HttpPost]
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
                    $"'{userForRegistration.Email}', '{_businessLogic.ConvertToSHA256(userForRegistration.Password)}', '{userForRegistration.ContactNum}', '{userForRegistration.BirthData}', {userForRegistration.Gender})";
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
                    docResponse.Error = "Incorrectly formated JSON request";
                    docResponse.Status = "500 - Internal Server Error";
                    docResponse.Method = "POST";
                    return BadRequest(docResponse);
                }
            }
            else
            {
                docResponse.Error = "Incorrectly formated JSON request";
                docResponse.Status = "500 - Internal Server Error";
                docResponse.Method = "POST";
                return BadRequest(docResponse);
            }

        }
    }
}
