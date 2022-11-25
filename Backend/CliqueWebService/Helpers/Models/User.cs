using System.Text.Json.Serialization;

namespace CliqueWebService.Helpers.Models
{
    public class User
    {
        public int? user_id { get; set; }
        public string? name { get; set; }
        public string? surname { get; set; }
        public string? email { get; set; }
        public string? gender { get; set; }
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]
        public string? password { get; set; }
        public string? contact_no { get; set; }
        public DateTime? birth_data { get; set; }
        public string? profile_pic { get; set; }
    }
}
