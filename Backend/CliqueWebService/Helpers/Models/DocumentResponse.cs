using CliqueWebService.Helpers.Models;
using System.Text.Json.Serialization;

namespace CliqueWebService.Helpers
{
    public class DocumentResponse
    {
        
        public string Status { get; set; }
        public string Method { get; set; }
        public List<Event>?  Events { get; set; }
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]
        public string Error { get; set; }
    }
}
