using System.Text.Json.Serialization;

namespace CliqueWebService.Helpers.Models
{
    public class Event
    {
        public int event_id { get; set; }
        public string event_name { get; set; }
        public string event_location { get; set; }
        public string event_timestamp { get; set; }
        public int participants_no { get; set; }
        public double? cost { get; set; }
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]
        public string? currency { get; set; }
        public string category { get; set; }
        public User creator { get; set; }
    }
}
