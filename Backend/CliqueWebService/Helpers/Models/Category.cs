using System.Text.Json.Serialization;

namespace CliqueWebService.Helpers.Models
{
    public class Category
    {
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]
        public int category_id { get; set; }
        public string category_name { get; set; }
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]
        public string? category_pic { get; set; }
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]
        public string? category_color { get; set; }
    }
}
