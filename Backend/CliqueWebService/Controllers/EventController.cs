﻿using Microsoft.AspNetCore.Mvc;
using DataAccess;
using CliqueWebService.Helpers;
using CliqueWebService.Helpers.Models;


namespace CliqueWebService.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EventController : ControllerBase
    {
        Database _db;
        BusinessLogic _businessLogic;
        private readonly IConfiguration _configuration;

        public EventController(IConfiguration configuration)
        {
            _configuration = configuration ?? throw new ArgumentNullException();
            _db = new Database(configuration.GetConnectionString("AzureDatabase"));
            _businessLogic = new BusinessLogic();
        }

        [HttpGet]
        [Route("GetAllEvents")]
        public ActionResult GetEvents()
        {
            try
            {
                _db.Connect();
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }

            string q = $"SELECT e.*, cur.currency_abbr, u.name, u.surname, u.email, cat.category_name, g.gender_name, u.user_id FROM Events e LEFT JOIN Categories cat ON e.category = cat.category_id LEFT JOIN Users u ON e.creator = u.user_id LEFT JOIN Currencies cur ON cur.currency_id = e.currency LEFT JOIN Gender g ON u.gender = g.gender_id";
            try
            {
                var reader = _db.ExecuteQuery(q);
                List<Event> events = new List<Event>();
                while (reader.Read())
                {
                    if (reader.GetValue(0) != DBNull.Value)
                    {
                        events.Add(_businessLogic.FillEvents(reader));
                    }
                }
                reader.Close();
                _db.Disconnect();
                return Ok(events);

            }
            catch (Exception ex)
            {
                _db.Disconnect();
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
        }

        [HttpGet]
        [Route("GetEventByID/{id}")]
        public ActionResult GetEventByID(int id)
        {
            try
            {
                _db.Connect();
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }

            try
            {
                List<Event> events = new List<Event>();
                string query = $"SELECT e.*, cur.currency_abbr, u.name, u.surname, u.email, cat.category_name, g.gender_name, u.user_id FROM Events e LEFT JOIN Categories cat ON e.category = cat.category_id LEFT JOIN Users u ON e.creator = u.user_id LEFT JOIN Currencies cur ON cur.currency_id = e.currency LEFT JOIN Gender g ON u.gender = g.gender_id WHERE e.event_id = {id} ";
                var reader = _db.ExecuteQuery(query);
                if (!reader.HasRows)
                {
                    return BadRequest($"Event with ID = {id} not found.");
                }
                while (reader.Read())
                {
                    if (reader.GetValue(0) != DBNull.Value)
                    {
                        events.Add(_businessLogic.FillEvents(reader));
                    }
                }
                reader.Close();
                _db.Disconnect();
                return Ok(events);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
        }

        [HttpGet("eventscreatedby/{user_id}")]
        public ActionResult GetEventsCreatedByUserID(int user_id)
        {
            try
            {
                _db.Connect();
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
            try
            {
                List<Event> events = new List<Event>();
                string query = $"SELECT e.*, cur.currency_abbr, u.name, u.surname, u.email, cat.category_name, g.gender_name, u.user_id FROM Events e LEFT JOIN Categories cat ON e.category = cat.category_id LEFT JOIN Users u ON e.creator = u.user_id LEFT JOIN Currencies cur ON cur.currency_id = e.currency LEFT JOIN Gender g ON u.gender = g.gender_id WHERE e.creator = {user_id} ";
                var reader = _db.ExecuteQuery(query);
                if (!reader.HasRows)
                {
                    return BadRequest("User didn't create any events");
                }
                while (reader.Read())
                {
                    if (reader.GetValue(0) != DBNull.Value)
                    {
                        events.Add(_businessLogic.FillEvents(reader));
                    }
                }
                reader.Close();
                _db.Disconnect();
                return Ok(events.ToList());
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
        }

        [HttpGet("eventssignedup/{user_id}")]
        public ActionResult GetEventsSignedUpByUserID(int user_id)
        {
            try
            {
                _db.Connect();
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
            try
            {
                List<Event> events = new List<Event>();
                string query = $"SELECT e.*, cur.currency_abbr, u.name, u.surname, u.email, cat.category_name, g.gender_name, u.user_id FROM Events e LEFT JOIN Categories cat ON e.category = cat.category_id LEFT JOIN Users u ON e.creator = u.user_id LEFT JOIN Currencies cur ON cur.currency_id = e.currency LEFT JOIN Gender g ON u.gender = g.gender_id LEFT JOIN signs_up_for sg ON e.event_id = sg.event_id WHERE sg.user_id = {user_id} OR e.creator = {user_id}";
                var reader = _db.ExecuteQuery(query);
                if (!reader.HasRows)
                {
                    return BadRequest("User isn't signed in any events.");
                }
                while (reader.Read())
                {
                    if (reader.GetValue(0) != DBNull.Value)
                    {
                        events.Add(_businessLogic.FillEvents(reader));
                    }
                }
                reader.Close();
                _db.Disconnect();
                return Ok(events.ToList());
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        [Route("CreateNewEvent")]
        public ActionResult CreateEvent([FromBody] CreateEventRequest request)
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

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState.Values.SelectMany(x => x.Errors).Select(x => x.ErrorMessage));
            }
            if (double.Parse(request.Cost) > 0 && (string.IsNullOrEmpty(request.Currency) || request.Currency == "0"))
            {
                return BadRequest("Please enter the currency");
            }
            _db.BeginTransaction();
            try
            {
                string desc = "";
                if (!string.IsNullOrEmpty(request.Description))
                {
                    desc = request.Description;
                }
                string query = "";

                if (request.Cost == "0")
                {
                    query = $"INSERT INTO Events(event_name, event_location, event_date, event_time, participations_no, creator, category, description)" +
                    $" VALUES ('{request.EventName}', '{request.EventLocation}', '{request.EventTimeStamp.ToString("yyyy-MM-dd")}', '{request.EventTimeStamp.ToString("HH:mm:ss")}', '{request.ParticipantsNo}', '{id}', '{request.Category}', '{desc}')";
                }
                else
                {
                    query = $"INSERT INTO Events(event_name, event_location, event_date, event_time, participations_no, cost, currency,creator, category, description)" +
                        $" VALUES ('{request.EventName}', '{request.EventLocation}', '{request.EventTimeStamp.ToString("yyyy-MM-dd")}', '{request.EventTimeStamp.ToString("HH:mm:ss")}', '{request.ParticipantsNo}', '{request.Cost}', '{request.Currency}','{id}', '{request.Category}', '{desc}')";
                }
                _db.ExecuteNonQuery(query);
                _db.CommitTransaction();
                return Ok("Event added");
            }
            catch
            {
                _db.RollbackTransaction();
                _db.CommitTransaction();
                return StatusCode(StatusCodes.Status500InternalServerError, "Server error");
            }
        }

        [HttpGet]
        [Route("GetCurrencies")]
        public ActionResult GetCurrencies()
        {
            List<Currency> currencies = new List<Currency>();
            try
            {
                _db.Connect();
            }
            catch
            {
                return StatusCode(StatusCodes.Status500InternalServerError, "Server Error");
            }

            try
            {
                string query = $"SELECT * FROM Currencies";
                var reader = _db.ExecuteQuery(query);
                while (reader.Read())
                {
                    if (reader.GetValue(0) != DBNull.Value)
                    {
                        currencies.Add(_businessLogic.FillCurrency(reader));
                    }
                }
                reader.Close();
            }
            catch
            {
                return StatusCode(StatusCodes.Status500InternalServerError, "Server Error");
            }
            return Ok(currencies);
        }

        [HttpGet]
        [Route("GetCategories")]
        public ActionResult GetCategories()
        {
            List<Category> categories = new List<Category>();
            try
            {
                _db.Connect();
            }
            catch
            {
                return StatusCode(StatusCodes.Status500InternalServerError, "Server Error");
            }

            try
            {
                string query = $"SELECT * FROM Categories";
                var reader = _db.ExecuteQuery(query);
                while (reader.Read())
                {
                    if (reader.GetValue(0) != DBNull.Value)
                    {
                        categories.Add(_businessLogic.FillCategory(reader));
                    }
                }
                reader.Close();
            }
            catch
            {
                return StatusCode(StatusCodes.Status500InternalServerError, "Server Error");
            }
            return Ok(categories);
        }
        [HttpPost]
        [Route("UpdateEvent/{eventID}")]
        public ActionResult UpdateEvent([FromBody] CreateEventRequest req, int eventId)
        {
            try
            {
                _db.Connect();
            }
            catch
            {
                return StatusCode(StatusCodes.Status500InternalServerError, "Server Error");
            }
            string userId = "0";
            if (Request.Headers.Keys.Contains("Authorization"))
            {
                string token = Request.Headers["Authorization"];
                if (_businessLogic.isJWTValid(token.Replace("Bearer ", "")))
                {
                    userId = User.Claims.FirstOrDefault(i => i.Type.Contains("UserId")).Value;
                }
            }
            if (userId == "0")
            {
                return Unauthorized();
            }

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState.Values.SelectMany(x => x.Errors).Select(x => x.ErrorMessage));
            }
            if (double.Parse(req.Cost) > 0 && (string.IsNullOrEmpty(req.Currency) || req.Currency == "0"))
            {
                return BadRequest("Please enter the currency");
            }
            _db.BeginTransaction();
            try
            {
                string desc = "";
                if (!string.IsNullOrEmpty(req.Description))
                {
                    desc = req.Description;
                }
                string query = "";
                if (req.Cost == "0")
                {
                    query = $"UPDATE Events SET event_name = '{req.EventName}', event_date = '{req.EventTimeStamp.ToString("yyyy-MM-dd")}'," +
                    $" event_time = '{req.EventTimeStamp.ToString("HH:mm:ss")}', event_location = '{req.EventLocation}', participations_no = {req.ParticipantsNo}," +
                    $" category = {req.Category}, description = '{desc}' WHERE event_id = {eventId}";
                }
                else
                {
                    query = $"UPDATE Events SET event_name = '{req.EventName}', event_date = '{req.EventTimeStamp.ToString("yyyy-MM-dd")}'," +
                    $" event_time = '{req.EventTimeStamp.ToString("HH:mm:ss")}', event_location = '{req.EventLocation}', participations_no = {req.ParticipantsNo}," +
                    $" category = {req.Category}, description = '{desc}', cost = {req.Cost}, currency = {req.Currency} WHERE event_id = {eventId}";
                }
                _db.ExecuteNonQuery(query);
                _db.CommitTransaction();
                return Ok("Event Updated.");
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
