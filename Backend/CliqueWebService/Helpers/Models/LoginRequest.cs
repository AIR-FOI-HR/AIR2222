using System.ComponentModel.DataAnnotations;

namespace CliqueWebService.Helpers.Models
{
    public class LoginRequest
    {
        [Required]
        public string Email { get; set; }

        [MinLength(8)]
        [Required]
        public string Password { get; set; }
    }
}
