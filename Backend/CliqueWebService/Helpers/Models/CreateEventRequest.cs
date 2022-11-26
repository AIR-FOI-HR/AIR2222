using System.Text.Json.Serialization;

namespace CliqueWebService.Helpers.Models
{
    public class CreateEventRequest
    {
        public string EventName { get; set; }
        public string EventLocation{ get; set; }
        public DateTime EventTimeStamp { get; set; }
        public int ParticipantsNo { get; set; }
        public double? Cost { get; set; }
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]
        public int? Currency { get; set; }
        public int Category { get; set; }
    }
}
