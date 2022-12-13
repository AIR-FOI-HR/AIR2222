using System.Text.Json.Serialization;

namespace CliqueWebService.Helpers.Models
{
    public class Participants
    {
        public User? Participant { get; set; }
        public int? Status { get; set; } 
    }
}
