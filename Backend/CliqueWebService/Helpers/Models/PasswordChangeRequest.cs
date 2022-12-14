using System.ComponentModel.DataAnnotations;

namespace CliqueWebService.Helpers.Models
{
    public class PasswordChangeRequest
    {
        [MinLength(8)]
        [Required]
        public string OldPassword { get; set; }
        [MinLength(8)]
        [Required]
        public string NewPassword { get; set; }
    }
}
