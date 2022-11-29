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

        [HttpGet]
        public ActionResult GetCurrentUser()
        {
            DocumentResponse returnResponse = new DocumentResponse();
            try
            {
                _db.Connect();
            } catch (Exception ex)
            {
                returnResponse.Method = "GET";
                returnResponse.Status = "0";
                returnResponse.Events = null;
                returnResponse.Error = ex.Message;
                return StatusCode(StatusCodes.Status500InternalServerError, returnResponse);
            }
            string id = "0";
            if (Request.Headers.Keys.Contains("Authorization"))
            {
                string token = Request.Headers["Authorization"];
                if (_businessLogic.isJWTValid(token.Replace("Bearer ", "")))
                {
                    id = User.Claims.FirstOrDefault(i => i.Type.Contains("UserId")).Value;
                }
            }
            if (id == "0")
            {
                returnResponse.Method = "POST";
                returnResponse.Error = "Unauthorized user";
                returnResponse.Status = "0";
                return Unauthorized(returnResponse);
            }
            try
            {
                List<User> user = new List<User>();
                string query = $"SELECT user_id, name, surname, email, gender_name, contact_no, birth_data, profile_pic, bio FROM Users LEFT JOIN Gender ON gender_id = gender WHERE user_id = {id}";
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
                    returnResponse.Status = "0";
                    returnResponse.Method = "GET";
                    returnResponse.Events = null;
                    returnResponse.Error = $"User with ID = {id} not found.";
                    return BadRequest(returnResponse);
                }

                returnResponse.Status = "1";
                returnResponse.Method = "GET";
                returnResponse.Users = user;
                return Ok(returnResponse);
            } catch (Exception ex)
            {
                _db.Disconnect();
                returnResponse.Status = "0";
                returnResponse.Method = "GET";
                returnResponse.Events = null;
                returnResponse.Error = ex.Message;
                return StatusCode(StatusCodes.Status500InternalServerError, returnResponse);
            }
        }

        [HttpGet("{id}")]
        public ActionResult GetUserByID(int id)
        {
            DocumentResponse returnResponse = new DocumentResponse();
            try
            {
                _db.Connect();
            }
            catch (Exception ex)
            {
                returnResponse.Method = "GET";
                returnResponse.Status = "0";
                returnResponse.Events = null;
                returnResponse.Error = ex.Message;
                return StatusCode(StatusCodes.Status500InternalServerError, returnResponse);
            }
            try
            {
                List<User> user = new List<User>();
                string query = $"SELECT user_id, name, surname, email, gender_name, contact_no, birth_data, profile_pic, bio FROM Users LEFT JOIN Gender ON gender_id = gender WHERE user_id = {id}";
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
                    returnResponse.Status = "0";
                    returnResponse.Method = "GET";
                    returnResponse.Events = null;
                    returnResponse.Error = $"User with ID = {id} not found.";
                    return BadRequest(returnResponse);
                }

                returnResponse.Status = "1";
                returnResponse.Method = "GET";
                returnResponse.Users = user;
                return Ok(returnResponse);
            }
            catch (Exception ex)
            {
                _db.Disconnect();
                returnResponse.Status = "0";
                returnResponse.Method = "GET";
                returnResponse.Events = null;
                returnResponse.Error = ex.Message;
                return StatusCode(StatusCodes.Status500InternalServerError, returnResponse);
            }
        }

        [HttpPost]
        [Route("UpdateUserData")]
        public ActionResult UpdateUserData([FromBody] User user)
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
                string query = $"UPDATE Users SET name = '{user.name}', surname = '{user.surname}', email = '{user.email}', contact_no = '{user.contact_no}', " +
                    $"birth_data = '{user.birth_data}', gender = {user.gender}, bio = '{user.bio}' WHERE user_id = {user.user_id}";
                _db.BeginTransaction();
                try
                {
                    _db.ExecuteNonQuery(query);
                    _db.CommitTransaction();
                    docResponse.Message = "User successfully updated";
                    docResponse.Status = "200 - OK";
                    docResponse.Method = "POST";
                    return Ok(docResponse);
                }
                catch
                {
                    _db.RollbackTransaction();
                    _db.CommitTransaction();
                    docResponse.Error = "Couldn't update user";
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

        [HttpPost]
        [Route("UpdateUserPassword")]
        public ActionResult UpdateUserPassword([FromBody] LoginRequest user)
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
                string query = $"UPDATE Users SET hash_password = '{_businessLogic.ConvertToSHA256(user.Password).ToLower()}' WHERE email = '{user.Email}'";
                _db.BeginTransaction();
                try
                {
                    _db.ExecuteNonQuery(query);
                    _db.CommitTransaction();
                    docResponse.Message = "Password successfully updated";
                    docResponse.Status = "200 - OK";
                    docResponse.Method = "POST";
                    return Ok(docResponse);
                }
                catch
                {
                    _db.RollbackTransaction();
                    _db.CommitTransaction();
                    docResponse.Error = "Couldn't update password";
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