using System;
using System.Net.Http;
using System.Text.Json;
using System.Threading.Tasks;
using Payment.Web.Models.ViewModels;

namespace Payment.Web.Services
{
    public class NodeApiClient : INodeApiClient
    {
        private readonly HttpClient _client;

        public NodeApiClient(HttpClient client)
        {
            _client = client;
        }

        // =========================
        // HEALTH CHECK
        // =========================
        // GET: /api/health
        public async Task<object?> HealthAsync()
        {
            try
            {
                var response = await _client.GetAsync("/api/health");

                if (!response.IsSuccessStatusCode)
                    return null;

                var json = await response.Content.ReadAsStringAsync();
                return JsonSerializer.Deserialize<object>(json);
            }
            catch
            {
                return null;
            }
        }

        // =========================
        // EXCHANGE RATE
        // =========================
        // GET: /api/rates?from=USD&to=TRY
        public async Task<RateViewModel?> RatesAsync(string from, string to)
        {
            try
            {
                var response = await _client.GetAsync($"/api/rates?from={from}&to={to}");

                if (!response.IsSuccessStatusCode)
                    return null;

                var json = await response.Content.ReadAsStringAsync();

                return JsonSerializer.Deserialize<RateViewModel>(
                    json,
                    new JsonSerializerOptions
                    {
                        PropertyNameCaseInsensitive = true
                    }
                );
            }
            catch
            {
                return null;
            }
        }

        // =========================
        // FRAUD CHECK (BİR SONRAKİ ADIM)
        // =========================
        // POST: /api/fraud/check
        public async Task<FraudResultViewModel?> CheckFraudAsync(FraudRequestViewModel request)
        {
            try
            {
                var json = JsonSerializer.Serialize(request);
                var content = new StringContent(json, System.Text.Encoding.UTF8, "application/json");

                var response = await _client.PostAsync("/api/fraud/check", content);

                if (!response.IsSuccessStatusCode)
                    return null;

                var resultJson = await response.Content.ReadAsStringAsync();

                return JsonSerializer.Deserialize<FraudResultViewModel>(
                    resultJson,
                    new JsonSerializerOptions
                    {
                        PropertyNameCaseInsensitive = true
                    }
                );
            }
            catch
            {
                return null;
            }
        }
    }
}
