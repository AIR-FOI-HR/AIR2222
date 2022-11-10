using System.Text.Json.Serialization;

namespace CliqueWebService.Helpers.Models
{
    public class Currency
    {
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]
        public int currency_id { get; set; }
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]
        public string currency_name { get; set; }
        public string currency_abbr { get; set; }
    }
}
