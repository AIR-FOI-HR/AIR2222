using System.ComponentModel.DataAnnotations;

namespace CliqueWebService.Helpers.Models
{
    public class RegisterRequest : LoginRequest
    {
        [Required]
        public string Name { get; set; }
        [Required]
        public string Surname { get; set; }
        [Required]
        [RegularExpression("([0-9]+)")]
        public string ContactNum { get; set; }
        [Required]
        public int Gender { get; set; }
        public string BirthData { get; set; }
    }
}
