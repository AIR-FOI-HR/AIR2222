﻿using Microsoft.AspNetCore.Mvc;
using DataAccess;
using CliqueWebService.Helpers;
using CliqueWebService.Helpers.Models;


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

        [HttpGet("CheckIfUserIsSigned")]
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
                List<Event> events = new List<Event>();
                string query = $"SELECT status_id FROM signs_up_for WHERE event_id = {event_id} AND user_id = {id};";
                var reader = _db.ExecuteQuery(query);
                if (!reader.HasRows)
                {
                    return BadRequest("Something went wrong!");
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


    }
}