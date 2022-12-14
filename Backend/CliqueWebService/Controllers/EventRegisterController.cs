using Microsoft.AspNetCore.Mvc;
using DataAccess;
using CliqueWebService.Helpers;
using CliqueWebService.Helpers.Models;
using System.Text.Json;

namespace CliqueWebService.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EventRegisterController : ControllerBase
    {
        Database _db;
        BusinessLogic _businessLogic;
        private readonly IConfiguration _configuration;

        public EventRegisterController(IConfiguration configuration)
        {
            _configuration = configuration ?? throw new ArgumentNullException();
            _db = new Database(configuration.GetConnectionString("AzureDatabase"));
            _businessLogic = new BusinessLogic();
        }

        [HttpGet("CheckIfUserIsSigned/{event_id}")]
        public ActionResult CheckIfUserIsSigned(int event_id)
        {
            try
            {
                _db.Connect();
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
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
                string query = $"SELECT status_id FROM signs_up_for WHERE event_id = {event_id} AND user_id = {id};";
                var reader = _db.ExecuteQuery(query);
                if (!reader.HasRows)
                {
                    return Ok(1);
                }
                int status_id = 0;
                while (reader.Read())
                {
                    if (reader.GetValue(0) != DBNull.Value)
                    {
                        status_id = reader.GetInt32(0);
                    }
                }
                reader.Close();
                _db.Disconnect();

                return Ok(status_id);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        [Route("RegisterOnEvent")]
        public ActionResult RegisterOnEvent([FromBody] JsonElement json)
        {
            try
            {
                _db.Connect();
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, "Server error");
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

            _db.BeginTransaction();
            try
            {
                int event_id = int.Parse(json.GetProperty("event_id").ToString());
                int status = int.Parse(json.GetProperty("status").ToString());
                string query = "";
                if(status < 2)
                {
                    query = $"INSERT INTO signs_up_for VALUES ({event_id}, {id},2)";
                    status = 2;
                }
                else if (status == 2)
                {
                    query = $"UPDATE signs_up_for SET status_id = 3 WHERE event_id = {event_id} AND user_id = {id}";
                    status = 3;
                } else if(status == 3)
                {
                    query = $"UPDATE signs_up_for SET status_id = 2 WHERE event_id = {event_id} AND user_id = {id}";
                    status = 2;
                }
                _db.ExecuteNonQuery(query);
                _db.CommitTransaction();
                return Ok(status);
            }
            catch
            {
                _db.RollbackTransaction();
                _db.CommitTransaction();
                return StatusCode(StatusCodes.Status500InternalServerError, "Server error");
            }
        }
    }
}
