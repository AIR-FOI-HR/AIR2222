using Microsoft.AspNetCore.Mvc;
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
        // GET: api/<EventController>

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
            string q = $"SELECT e.*, cur.currency_abbr, u.name, u.surname, u.email, cat.category_name, g.gender_name, u.user_id FROM Events e LEFT JOIN Categories cat ON e.category = cat.category_id LEFT JOIN Users u ON e.creator = u.user_id LEFT JOIN Currencies cur ON cur.currency_id = e.currency LEFT JOIN Gender g ON u.gender = g.gender_id";
            try
            {
                bool idExists = true;
                var reader = _db.ExecuteQuery(q);
                List<Event> events = new List<Event>();
                while (reader.Read())
                {
                    if (reader.GetValue(0) != DBNull.Value)
                    {
                        events.Add(_businessLogic.FillEvents(reader));
                    }
                    else
                    {
                        idExists = false;
                        break;
                    }
                }
                reader.Close();

                _db.Disconnect();

                returnResponse.Status = "1";
                returnResponse.Method = "GET";
                returnResponse.Events = events;
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

        // GET api/<EventController>/5
        [HttpGet]
        [Route("GetEventByID/{id}")]
        public ActionResult GetEventByID(int id)
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
                List<Event> events = new List<Event>();
                string query = $"SELECT e.*, cur.currency_abbr, u.name, u.surname, u.email, cat.category_name, g.gender_name, u.user_id FROM Events e LEFT JOIN Categories cat ON e.category = cat.category_id LEFT JOIN Users u ON e.creator = u.user_id LEFT JOIN Currencies cur ON cur.currency_id = e.currency LEFT JOIN Gender g ON u.gender = g.gender_id WHERE e.event_id = {id} ";
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
                        events.Add(_businessLogic.FillEvents(reader));
                    }
                }
                reader.Close();
                _db.Disconnect();
                if (!idExists)
                {
                    returnResponse.Status = "0";
                    returnResponse.Method = "GET";
                    returnResponse.Events = null;
                    returnResponse.Error = $"Event with ID = {id} not found.";
                    return BadRequest(returnResponse);
                }

                returnResponse.Events = events.ToList();
                returnResponse.Status = "1";
                returnResponse.Method = "GET";
                return Ok(returnResponse);
            }
            catch (Exception ex)
            {
                returnResponse.Status = "0";
                returnResponse.Method = "GET";
                returnResponse.Events = null;
                returnResponse.Error = ex.Message;
                return StatusCode(StatusCodes.Status500InternalServerError, returnResponse);
            }
        }

        [HttpGet("eventscreatedby/{user_id}")]
        public ActionResult GetEventsCreatedByUserID(int user_id)
        {
            DocumentResponse returnResponse = new DocumentResponse();
            try
            {
                _db.Connect();
            }
            catch (Exception ex)
            {
                returnResponse.Method = "GET";
                returnResponse.Status = "500 - Internal Server Error";
                returnResponse.Events = null;
                returnResponse.Error = ex.Message;
                return StatusCode(StatusCodes.Status500InternalServerError, returnResponse);
            }
            try
            {
                List<Event> events = new List<Event>();
                string query = $"SELECT e.*, cur.currency_abbr, u.name, u.surname, u.email, cat.category_name, g.gender_name, u.user_id FROM Events e LEFT JOIN Categories cat ON e.category = cat.category_id LEFT JOIN Users u ON e.creator = u.user_id LEFT JOIN Currencies cur ON cur.currency_id = e.currency LEFT JOIN Gender g ON u.gender = g.gender_id WHERE e.creator = {user_id} ";
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
                        events.Add(_businessLogic.FillEvents(reader));
                    }
                }
                reader.Close();
                _db.Disconnect();
                if (!idExists)
                {
                    returnResponse.Status = "400 - Bad Request";
                    returnResponse.Method = "GET";
                    returnResponse.Events = null;
                    returnResponse.Error = $"User didn't create any events";
                    return BadRequest(returnResponse);
                }

                returnResponse.Events = events.ToList();
                returnResponse.Status = "200 - OK";
                returnResponse.Method = "GET";
                return Ok(returnResponse);
            }
            catch (Exception ex)
            {
                returnResponse.Status = "500 - Internal Server Error";
                returnResponse.Method = "GET";
                returnResponse.Events = null;
                returnResponse.Error = ex.Message;
                return StatusCode(StatusCodes.Status500InternalServerError, returnResponse);
            }
        }

        [HttpGet("eventssignedup/{user_id}")]
        public ActionResult GetEventsSignedUpByUserID(int user_id)
        {
            DocumentResponse returnResponse = new DocumentResponse();
            try
            {
                _db.Connect();
            }
            catch (Exception ex)
            {
                returnResponse.Method = "GET";
                returnResponse.Status = "500 - Internal Server Error";
                returnResponse.Events = null;
                returnResponse.Error = ex.Message;
                return StatusCode(StatusCodes.Status500InternalServerError, returnResponse);
            }
            try
            {
                List<Event> events = new List<Event>();
                string query = $"SELECT e.*, cur.currency_abbr, u.name, u.surname, u.email, cat.category_name, g.gender_name, u.user_id FROM Events e LEFT JOIN Categories cat ON e.category = cat.category_id LEFT JOIN Users u ON e.creator = u.user_id LEFT JOIN Currencies cur ON cur.currency_id = e.currency LEFT JOIN Gender g ON u.gender = g.gender_id LEFT JOIN signs_up_for sg ON e.event_id = sg.event_id WHERE sg.user_id = {user_id} OR e.creator = {user_id}";
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
                        events.Add(_businessLogic.FillEvents(reader));
                    }
                }
                reader.Close();
                _db.Disconnect();
                if (!idExists)
                {
                    returnResponse.Status = "400 - Bad Request";
                    returnResponse.Method = "GET";
                    returnResponse.Events = null;
                    returnResponse.Error = $"User isn't signed in any events.";
                    return BadRequest(returnResponse);
                }

                returnResponse.Events = events.ToList();
                returnResponse.Status = "200 - OK";
                returnResponse.Method = "GET";
                return Ok(returnResponse);
            }
            catch (Exception ex)
            {
                returnResponse.Status = "500 - Internal Server Error";
                returnResponse.Method = "GET";
                returnResponse.Events = null;
                returnResponse.Error = ex.Message;
                return StatusCode(StatusCodes.Status500InternalServerError, returnResponse);
            }
        }

        [HttpPost]
        [Route("CreateNewEvent")]
        public ActionResult CreateEvent([FromBody] CreateEventRequest request)
        {
            DocumentResponse dr = new DocumentResponse();
            try
            {
                _db.Connect();
            }
            catch (Exception ex)
            {
                dr.Method = "POST";
                dr.Status = "0";
                dr.Error = "Server Error";
                return StatusCode(StatusCodes.Status500InternalServerError, dr);
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
                dr.Method = "POST";
                dr.Error = "Unauthorized user";
                dr.Status = "0";
                return Unauthorized(dr);
            }
            if (!ModelState.IsValid)
            {
                dr.Method = "POST";
                dr.Errors = ModelState.Values.SelectMany(x => x.Errors).Select(x => x.ErrorMessage);
                dr.Status = "0";
                return BadRequest(dr);
            }
            if (request.Cost != "0" && string.IsNullOrEmpty(request.Currency))
            {
                dr.Method = "POST";
                dr.Error = "Please enter the currency";
                dr.Status = "0";
                return BadRequest(dr);
            }
            _db.BeginTransaction();
            try
            {
                string desc = "";
                if (!string.IsNullOrEmpty(request.Description))
                {
                    desc = request.Description;
                }
                string q = "";

                if (request.Cost == "0")
                {
                    q = $"INSERT INTO Events(event_name, event_location, event_date, event_time, participations_no, creator, category, description)" +
                    $" VALUES ('{request.EventName}', '{request.EventLocation}', '{request.EventTimeStamp.ToString("yyyy-MM-dd")}', '{request.EventTimeStamp.ToString("HH:mm:ss")}', '{request.ParticipantsNo}', '{id}', '{request.Category}', '{desc}')";
                }
                else
                {
                    q = $"INSERT INTO Events(event_name, event_location, event_date, event_time, participations_no, cost, currency,creator, category, description)" +
                        $" VALUES ('{request.EventName}', '{request.EventLocation}', '{request.EventTimeStamp.ToString("yyyy-MM-dd")}', '{request.EventTimeStamp.ToString("HH:mm:ss")}', '{request.ParticipantsNo}', '{request.Cost}', '{request.Currency}','{id}', '{request.Category}', {desc})";
                }
                _db.ExecuteNonQuery(q);
                _db.CommitTransaction();
                dr.Method = "POST";
                dr.Message = "Event Added";
                dr.Status = "1";
                return Ok(dr);
            }
            catch
            {
                _db.RollbackTransaction();
                _db.CommitTransaction();
                dr.Method = "POST";
                dr.Error = "Server Error";
                dr.Status = "0";
                return StatusCode(StatusCodes.Status500InternalServerError, dr);
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
    }
}
