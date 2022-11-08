using CliqueWebService.Helpers.Models;
using System.Data.SqlClient;

namespace CliqueWebService.Helpers
{
    public class BusinessLogic
    {
        public Event FillEvents(SqlDataReader reader)
        {
            Event ev = new Event
            {
                event_id = reader.GetInt32(0),
                event_name = reader.GetString(1),
                event_location = reader.GetString(2),
                event_date = reader.GetDateTime(3).ToString(),
                event_time = reader.GetTimeSpan(4).ToString(),
                participants_no = reader.GetInt32(5),
                cost = (reader.GetValue(6) != DBNull.Value) ? reader.GetDouble(6) : 0,
                currency = (reader.GetValue(10) != DBNull.Value) ? reader.GetString(10) : null,
                creator = new User
                {
                    user_id = reader.GetInt32(16),
                    name = reader.GetString(11),
                    surname = reader.GetString(12),
                    email = reader.GetString(13),
                    gender = reader.GetString(15)
                },
                category = reader.GetString(14)
            };
            return ev;
        }
    }
}
