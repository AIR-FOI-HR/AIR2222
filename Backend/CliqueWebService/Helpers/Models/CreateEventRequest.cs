using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace CliqueWebService.Helpers.Models
{
    public class CreateEventRequest
    {
        [Required]
        public string EventName { get; set; }
        [Required]
        public string EventLocation{ get; set; }
        [Required]
        [RegularExpression("[0-9]*", ErrorMessage = "Invalid format for timestamp")]
        public string EventTimeStamp { get; set; }
        [Required]
        [RegularExpression("[0-9]*", ErrorMessage = "Invalid number of participants")]
        public string ParticipantsNo { get; set; }
        [Required]
        [RegularExpression("[0-9].*", ErrorMessage = "Invalid cost format")]
        public string Cost { get; set; }
        [RegularExpression("[0-9]*", ErrorMessage = "Select currency")]
        public string Currency { get; set; }
        [Required]
        [RegularExpression("[0-9]*", ErrorMessage = "Select category")]
        public string Category { get; set; }

        public string Description { get; set; }

        public string LocationLatitude { get; set; }
        public string LocationLongitude { get; set; }

    }
}
