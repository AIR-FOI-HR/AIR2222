using Microsoft.AspNetCore.Mvc;
using DataAccess;
using CliqueWebService.Helpers;
using CliqueWebService.Helpers.Models;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;

namespace CliqueWebService.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        Database _db;
        BusinessLogic _businessLogic;
        string storageConnection;
        private readonly IConfiguration _configuration;
        // GET: api/<EventController>

        public UserController(IConfiguration configuration)
        {
            _configuration = configuration ?? throw new ArgumentNullException();
            _db = new Database(configuration.GetConnectionString("AzureDatabase"));
            storageConnection = configuration.GetConnectionString("AzureStorage");
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
                returnResponse.Error = "Unauthorized user";
                returnResponse.Status = "0";
                return Unauthorized(returnResponse);
            }
            try
            {
                //List<User> user = new List<User>();
                User user = new User();
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
                        // user.Add(_businessLogic.GetUsers(reader));
                        user = _businessLogic.GetUsers(reader);
                    }
                }

                reader.Close();
                _db.Disconnect();

                if (!idExists)
                {
                    returnResponse.Status = "0";
                    returnResponse.Events = null;
                    returnResponse.Error = $"User with ID = {id} not found.";
                    return BadRequest(returnResponse);
                }

                returnResponse.Status = "1";
                returnResponse.User = user;
                return Ok(returnResponse);
            } catch (Exception ex)
            {
                _db.Disconnect();
                returnResponse.Status = "0";
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
                returnResponse.Status = "0";
                returnResponse.Events = null;
                returnResponse.Error = ex.Message;
                return StatusCode(StatusCodes.Status500InternalServerError, returnResponse);
            }
            try
            {
                //List<User> user = new List<User>();
                User user = new User();
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
                        //user.Add(_businessLogic.GetUsers(reader));
                        user = _businessLogic.GetUsers(reader);
                    }
                }

                reader.Close();
                _db.Disconnect();

                if (!idExists)
                {
                    returnResponse.Status = "0";
                    returnResponse.Events = null;
                    returnResponse.Error = $"User with ID = {id} not found.";
                    return BadRequest(returnResponse);
                }

                returnResponse.Status = "1";
                returnResponse.User = user;
                return Ok(returnResponse);
            }
            catch (Exception ex)
            {
                _db.Disconnect();
                returnResponse.Status = "0";
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
                docResponse.Error = "Unauthorized user";
                docResponse.Status = "0";
                return Unauthorized(docResponse);
            }
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
                string query = $"UPDATE Users SET name = '{user.name}', surname = '{user.surname}', email = '{user.email}', contact_no = '{user.contact_no}', " +
                    $"birth_data = '{user.birth_data}', gender = {user.gender}, bio = '{user.bio}' WHERE user_id = {id}";
                _db.BeginTransaction();
                try
                {
                    _db.ExecuteNonQuery(query);
                    _db.CommitTransaction();
                    docResponse.Message = "User successfully updated";
                    docResponse.Status = "1";
                    return Ok(docResponse);
                }
                catch
                {
                    _db.RollbackTransaction();
                    _db.CommitTransaction();
                    docResponse.Error = "Couldn't update user";
                    docResponse.Status = "0";
                    return StatusCode(StatusCodes.Status500InternalServerError, docResponse);
                }
            }
            else
            {
                docResponse.Error = "Incorrectly formated JSON request";
                docResponse.Status = "0";
                return BadRequest(docResponse);
            }
        }

        [HttpPost]
        [Route("UpdateUserPassword")]
        public ActionResult UpdateUserPassword([FromBody] PasswordChangeRequest passwordChangeRequest)
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
                    docResponse.Error = "Unauthorized user";
                    docResponse.Status = "0";
                    return Unauthorized(docResponse);
                }
                string passFromDB = "";
                string q1 = $"SELECT hash_password FROM Users WHERE user_id = {id}";
                var reader = _db.ExecuteQuery(q1);
                while (reader.Read())
                {
                    if(reader.GetValue(0) != DBNull.Value)
                    {
                        passFromDB = reader.GetString(0);
                    }
                }
                reader.Close();
                if (passFromDB.ToLower() != _businessLogic.ConvertToSHA256(passwordChangeRequest.OldPassword).ToLower())
                {
                    docResponse.Message = "Old password is incorrect";
                    docResponse.Status = "0";
                    return BadRequest(docResponse);
                }
                string query = $"UPDATE Users SET hash_password = '{_businessLogic.ConvertToSHA256(passwordChangeRequest.NewPassword).ToLower()}' WHERE user_id = '{id}'";
                _db.BeginTransaction();
                try
                {
                    int count = _db.ExecuteNonQuery(query);
                    _db.CommitTransaction();
                    if(count > 0)
                    {
                        docResponse.Message = "Password successfully updated";
                        docResponse.Status = "1";
                        return Ok(docResponse);

                    } else
                    {
                        docResponse.Message = "Old password is incorrect";
                        docResponse.Status = "0";
                        return BadRequest(docResponse);
                    }
                }
                catch
                {
                    _db.RollbackTransaction();
                    _db.CommitTransaction();
                    docResponse.Error = "Couldn't update password";
                    docResponse.Status = "0";
                    return StatusCode(StatusCodes.Status500InternalServerError, docResponse);
                }
            }
            else
            {
                docResponse.Error = "Incorrectly formated JSON request";
                docResponse.Status = "0";
                return BadRequest(docResponse);
            }
        }

        [HttpPost]
        [Route("UploadProfileImage")]
        public async Task<IActionResult> Run(IFormFile file)
        {
            if (file == null || file.Length == 0)
            {
                return BadRequest();
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
                return Unauthorized();
            }
            try
            {
                string containerName = "file-upload";
                Stream myBlob = new MemoryStream();
                myBlob = file.OpenReadStream();
                var blobClient = new BlobContainerClient(storageConnection, containerName);
                var blob = blobClient.GetBlobClient("user_" + id + ".jpg");
                blob.DeleteIfExists(DeleteSnapshotsOption.IncludeSnapshots);
                await blob.UploadAsync(myBlob);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError);
            }

            try
            {
                _db.Connect();
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
            string query = $"UPDATE Users SET profile_pic = 'https://cliquestorage.blob.core.windows.net/file-upload/user_{id}.jpg' WHERE user_id = '{id}'";
            _db.BeginTransaction();
            try
            {
                _db.ExecuteNonQuery(query);
                _db.CommitTransaction();
                return Ok($"https://cliquestorage.blob.core.windows.net/file-upload/user_{id}.jpg");
            }
            catch
            {
                _db.RollbackTransaction();
                _db.CommitTransaction();
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }
        [HttpGet]
        [Route("GetProfilePic")]
        public ActionResult GetProfilePic()
        {
            try
            {
                _db.Connect();
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError);
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
                return Unauthorized();
            }
            string url = "";
            string q = $"SELECT profile_pic FROM Users WHERE user_id = {id}";
            var reader = _db.ExecuteQuery(q);
            while (reader.Read())
            {
                if (reader.GetValue(0) != DBNull.Value && !string.IsNullOrEmpty(reader.GetString(0)))
                {
                    url = reader.GetString(0);
                }
                else
                {
                    url = "https://cliquestorage.blob.core.windows.net/file-upload/user_0.jpg";
                }
            }
            reader.Close();
            return Ok(url);
        }
    }
}