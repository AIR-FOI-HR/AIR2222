using System.ComponentModel.DataAnnotations;

namespace CliqueWebService.Helpers.Models
{
    public class RegisterRequest : LoginRequest
    {
        [Required]
        [RegularExpression("[a-zA-Z ]*", ErrorMessage = "Wrong format for Name")]
        public string Name { get; set; }
        [Required]
        [RegularExpression("[a-zA-Z -]*", ErrorMessage = "Wrong format for Surname")]
        public string Surname { get; set; }

    }
}
