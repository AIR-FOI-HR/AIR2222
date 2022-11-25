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
        public ActionResult GetEvents()
        {
            DocumentResponse returnResponse = new DocumentResponse();
            try
            {
                _db.Connect();
            }catch (Exception ex)
            {
                returnResponse.Method = "GET";
                returnResponse.Status = "500 - Internal Server Error";
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

                returnResponse.Status = "200 - OK";
                returnResponse.Method = "GET";
                returnResponse.Events = events;
                return Ok(returnResponse);

            }catch (Exception ex)
            {
                _db.Disconnect();
                returnResponse.Status = "500 - Internal Server Error";
                returnResponse.Method = "GET";
                returnResponse.Events = null;
                returnResponse.Error = ex.Message;
                return StatusCode(StatusCodes.Status500InternalServerError, returnResponse);
            }
        }

        // GET api/<EventController>/5
        [HttpGet("{id}")]
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
                returnResponse.Status = "500 - Internal Server Error";
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
                if(!reader.HasRows)
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
                    returnResponse.Error = $"Event with ID = {id} not found.";
                    return BadRequest(returnResponse);
                }

                returnResponse.Events = events.ToList();
                returnResponse.Status = "200 - OK";
                returnResponse.Method = "GET";
                return Ok(returnResponse);
            }
            catch(Exception ex)
            {
                returnResponse.Status = "500 - Internal Server Error";
                returnResponse.Method = "GET";
                returnResponse.Events = null;
                returnResponse.Error = ex.Message;
                return StatusCode(StatusCodes.Status500InternalServerError,returnResponse);
            }
        }

        [HttpGet("event/{user_id}")]
        public ActionResult GetEventsByUserID(int user_id)
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
                string query = $"SELECT e.*, cur.currency_abbr, u.name, u.surname, u.email, cat.category_name, g.gender_name, u.user_id FROM Events e LEFT JOIN Categories cat ON e.category = cat.category_id LEFT JOIN Users u ON e.creator = u.user_id LEFT JOIN Currencies cur ON cur.currency_id = e.currency LEFT JOIN Gender g ON u.gender = g.gender_id WHERE u.user_id = {user_id} ";
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
                    returnResponse.Error = $"Event with ID = {user_id} not found.";
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

            //// POST api/<EventController>
            //[HttpPost]
            //public void Post([FromBody] string value)
            //{
            //}

            //// PUT api/<EventController>/5
            //[HttpPut("{id}")]
            //public void Put(int id, [FromBody] string value)
            //{
            //}

            //// DELETE api/<EventController>/5
            //[HttpDelete("{id}")]
            //public void Delete(int id)
            //{
            //}
        }
}
