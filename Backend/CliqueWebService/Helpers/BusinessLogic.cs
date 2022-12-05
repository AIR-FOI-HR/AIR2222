using CliqueWebService.Helpers.Models;
using System.Data.SqlClient;
using System.IdentityModel.Tokens.Jwt;
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
                gender = (reader.GetValue(4) != DBNull.Value) ? reader.GetString(4).Trim() : null,
                contact_no = (reader.GetValue(5) != DBNull.Value) ? reader.GetString(5).Trim() : null,
                birth_data = (reader.GetValue(6) != DBNull.Value) ? reader.GetDateTime(6) : null,
                profile_pic = (reader.GetValue(7) != DBNull.Value) ? reader.GetString(7) : null,
                bio = (reader.GetValue(8) != DBNull.Value) ? reader.GetString(8) : null
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
                currency = (reader.GetValue(11) != DBNull.Value) ? reader.GetString(11) : null,
                creator = new User
                {
                    user_id = reader.GetInt32(17),
                    name = reader.GetString(12),
                    surname = reader.GetString(13),
                    email = reader.GetString(14),
                    gender = (reader.GetValue(16) != DBNull.Value) ? reader.GetString(16).Trim() : null
                },
                category = reader.GetString(15),
                description = (reader.GetValue(10) != DBNull.Value) ? reader.GetString(10) : null
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
                return false;
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
        public Category FillCategory(SqlDataReader reader)
        {
            Category ev = new Category
            {
                category_id = reader.GetInt32(0),
                category_name = reader.GetString(1),
                category_pic = (reader.GetValue(2) != DBNull.Value) ? reader.GetString(2) : null,
                category_color = reader.GetString(3)
            };
            return ev;
        }

        public Currency FillCurrency(SqlDataReader reader)
        {
            Currency ev = new Currency
            {
                currency_id = reader.GetInt32(0),
                currency_name = reader.GetString(1),
                currency_abbr = reader.GetString(2)
            };
            return ev;
        }
        public bool isJWTValid(string token)
        { 
            var exp = GetTokenExpirationTime(token);
            var tokenDate = DateTimeOffset.FromUnixTimeSeconds(exp).UtcDateTime;

            var now = DateTime.Now.ToUniversalTime();

            var valid = tokenDate >= now;

            return valid;
        }
        public long GetTokenExpirationTime(string token)
        {
            var jwt = new JwtSecurityTokenHandler();
            var jwtSecurityToken = jwt.ReadJwtToken(token);
            var tokenExp = jwtSecurityToken.Claims.First(claim => claim.Type.Equals("exp")).Value;
            var ticks = long.Parse(tokenExp);
            return ticks;
        }
    }
}
