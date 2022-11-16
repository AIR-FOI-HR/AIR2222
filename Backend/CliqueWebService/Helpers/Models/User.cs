using System.Text.Json.Serialization;

namespace CliqueWebService.Helpers.Models
{
    public class User
    {
        public int? user_id { get; set; }
        public string? name { get; set; }
        public string? surname { get; set; }
        public string? email { get; set; }
        public int? gender { get; set; }
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]
        public string? password { get; set; }
    }
}
