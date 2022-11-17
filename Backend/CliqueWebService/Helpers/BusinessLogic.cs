using CliqueWebService.Helpers.Models;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;

namespace CliqueWebService.Helpers
{
    public class BusinessLogic
    {
        public User GetUsers(SqlDataReader reader)
        {
            User user = new User
            {
                user_id = reader.GetInt32(0),
                name = reader.GetString(1),
                surname = reader.GetString(2),
                email = reader.GetString(3),
                gender = reader.GetString(4).Trim()
            };

            return user;
        }

        public Event FillEvents(SqlDataReader reader)
        {
            Event ev = new Event
            {
                event_id = reader.GetInt32(0),
                event_name = reader.GetString(1),
                event_location = reader.GetString(2),
                event_timestamp = reader.GetDateTime(3).ToString("dd/MM/yyyy") + " " + reader.GetTimeSpan(4).ToString(),
                participants_no = reader.GetInt32(5),
                cost = (reader.GetValue(6) != DBNull.Value) ? reader.GetDouble(6) : 0,
                currency = (reader.GetValue(10) != DBNull.Value) ? reader.GetString(10) : null,
                creator = new User
                {
                    user_id = reader.GetInt32(16),
                    name = reader.GetString(11),
                    surname = reader.GetString(12),
                    email = reader.GetString(13),
                    gender = reader.GetString(15).Trim()
                },
                category = reader.GetString(14)
            };
            return ev;
        }
        public string ConvertToSHA256(string pass)
        {
            StringBuilder builder = new StringBuilder();
            using(var hash = SHA256.Create())
            {
                byte[] stringHash = hash.ComputeHash(Encoding.UTF8.GetBytes(pass));
                foreach(byte b in stringHash)
                {
                    builder.Append(b.ToString("X2"));
                }
            }
            return builder.ToString();
        }
        public bool IsValidEmail(string email)
        {
            var trimmedEmail = email.Trim();

            if (trimmedEmail.EndsWith("."))
            {
                return false; // suggested by @TK-421
            }
            try
            {
                var addr = new System.Net.Mail.MailAddress(email);
                return addr.Address == trimmedEmail;
            }
            catch
            {
                return false;
            }
        }
    }
}
