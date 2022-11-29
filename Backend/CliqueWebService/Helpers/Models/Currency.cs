using System.Text.Json.Serialization;

namespace CliqueWebService.Helpers.Models
{
    public class Currency
    {
        public int currency_id { get; set; }
        public string currency_name { get; set; }
        public string currency_abbr { get; set; }
    }
}
