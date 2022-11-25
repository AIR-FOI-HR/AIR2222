using Microsoft.AspNetCore.Mvc;
using DataAccess;
using CliqueWebService.Helpers;
using CliqueWebService.Helpers.Models;

namespace CliqueWebService.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        Database _db;
        BusinessLogic _businessLogic;
        private readonly IConfiguration _configuration;
        // GET: api/<EventController>

        public UserController(IConfiguration configuration)
        {
            _configuration = configuration ?? throw new ArgumentNullException();
            _db = new Database(configuration.GetConnectionString("AzureDatabase"));
            _businessLogic = new BusinessLogic();
        }

        [HttpGet("{id}")]
        public ActionResult GetUserByID(int id)
        {
            DocumentResponse returnResponse = new DocumentResponse();
            try
            {
                _db.Connect();
            } catch (Exception ex)
            {
                returnResponse.Method = "GET";
                returnResponse.Status = "500 - Internal Server Error";
                returnResponse.Events = null;
                returnResponse.Error = ex.Message;
                return StatusCode(StatusCodes.Status500InternalServerError, returnResponse);
            }
            try
            {
                List<User> user = new List<User>();
                string query = $"SELECT user_id, name, surname, email, gender_name, contact_no, birth_data, profile_pic FROM Users, Gender WHERE user_id = {id} AND gender_id = gender";
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

                reader.Close();
                _db.Disconnect();

                if (!idExists)
                {
                    returnResponse.Status = "400 - Bad Request";
                    returnResponse.Method = "GET";
                    returnResponse.Events = null;
                    returnResponse.Error = $"User with ID = {id} not found.";
                    return BadRequest(returnResponse);
                }

                returnResponse.Status = "200 - OK";
                returnResponse.Method = "GET";
                returnResponse.Users = user;
                return Ok(returnResponse);
            } catch (Exception ex)
            {
                _db.Disconnect();
                returnResponse.Status = "500 - Internal Server Error";
                returnResponse.Method = "GET";
                returnResponse.Events = null;
                returnResponse.Error = ex.Message;
                return StatusCode(StatusCodes.Status500InternalServerError, returnResponse);
            }
        }
    }
}