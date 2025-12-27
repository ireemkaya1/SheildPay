using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Payment.Web.Data;
using Payment.Web.Models;
using Payment.Web.Models.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace Payment.Web.Controllers
{
    public class TransactionsController : Controller
    {
        private readonly AppDbContext _context;
        private readonly IHttpClientFactory _httpClientFactory;
        private readonly string _nodeApiBaseUrl;

        public TransactionsController(AppDbContext context, IHttpClientFactory httpClientFactory, IConfiguration config)
        {
            _context = context;
            _httpClientFactory = httpClientFactory;
            _nodeApiBaseUrl = config["NodeApi:BaseUrl"] ?? "http://localhost:3001";
        }

        private bool IsLoggedIn()
        {
            var user = HttpContext.Session.GetString("Username") ?? HttpContext.Session.GetString("username");
            return !string.IsNullOrWhiteSpace(user);
        }

        private async Task<FraudResultViewModel> PredictFraudAsync(string sender, string receiver, decimal amount)
        {
            try
            {
                var http = _httpClientFactory.CreateClient();
                var url = $"{_nodeApiBaseUrl.TrimEnd('/')}/predict";

                var reqBody = new FraudRequestViewModel
                {
                    Sender = sender,
                    Receiver = receiver,
                    Amount = amount
                };

                var json = JsonSerializer.Serialize(reqBody);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var resp = await http.PostAsync(url, content);
                if (!resp.IsSuccessStatusCode)
                    return new FraudResultViewModel { IsFraud = false };

                var raw = await resp.Content.ReadAsStringAsync();
                return JsonSerializer.Deserialize<FraudResultViewModel>(
                           raw,
                           new JsonSerializerOptions { PropertyNameCaseInsensitive = true }
                       )
                       ?? new FraudResultViewModel { IsFraud = false };
            }
            catch
            {
                return new FraudResultViewModel { IsFraud = false };
            }
        }

        // GET: /Transactions/Index
        public async Task<IActionResult> Index()
        {
            if (!IsLoggedIn()) return RedirectToAction("Login", "Account");

            var list = await _context.Transactions
                .OrderByDescending(x => x.CreatedAt)
                .ToListAsync();

            return View(list);
        }

        // GET: /Transactions/Details/5
        public async Task<IActionResult> Details(int id)
        {
            if (!IsLoggedIn()) return RedirectToAction("Login", "Account");

            var tx = await _context.Transactions.FirstOrDefaultAsync(x => x.Id == id);
            if (tx == null) return NotFound();

            return View(tx);
        }

        // GET: /Transactions/Create
        [HttpGet]
        public IActionResult Create()
        {
            if (!IsLoggedIn()) return RedirectToAction("Login", "Account");
            return View(new TransactionCreateViewModel());
        }

        // POST: /Transactions/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(TransactionCreateViewModel model)
        {
            if (!IsLoggedIn()) return RedirectToAction("Login", "Account");
            if (!ModelState.IsValid) return View(model);

            var fraud = await PredictFraudAsync(model.Sender, model.Receiver, model.Amount);

            var tx = new Transaction
            {
                Sender = model.Sender,
                Receiver = model.Receiver,
                Amount = model.Amount,
                CreatedAt = DateTime.Now,
                IsFraud = fraud.IsFraud,
                FraudScore = fraud.FraudScore,
                FraudReason = fraud.FraudReason ?? ""
            };

            _context.Transactions.Add(tx);
            await _context.SaveChangesAsync();

            TempData["Success"] = tx.IsFraud ? "Şüpheli İşlem Tespit Edildi!" : "İşlem Başarılı.";
            return RedirectToAction(nameof(Index));
        }

        // GET: /Transactions/Edit/5
        [HttpGet]
        public async Task<IActionResult> Edit(int id)
        {
            if (!IsLoggedIn()) return RedirectToAction("Login", "Account");

            var tx = await _context.Transactions.FirstOrDefaultAsync(x => x.Id == id);
            if (tx == null) return NotFound();

            // Edit.cshtml @model Payment.Web.Models.Transaction olmalı
            return View(tx);
        }

        // POST: /Transactions/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, Transaction form)
        {
            if (!IsLoggedIn()) return RedirectToAction("Login", "Account");
            if (id != form.Id) return BadRequest();

            var tx = await _context.Transactions.FirstOrDefaultAsync(x => x.Id == id);
            if (tx == null) return NotFound();

            // İstersen sender/receiver'ı da edit edebilirsin; edit ekranında yoksa DB'dekiler kalır
            if (!string.IsNullOrWhiteSpace(form.Sender)) tx.Sender = form.Sender;
            if (!string.IsNullOrWhiteSpace(form.Receiver)) tx.Receiver = form.Receiver;

            tx.Amount = form.Amount;

            // Edit sonrası fraud'u tekrar hesapla (demo için iyi)
            var fraud = await PredictFraudAsync(tx.Sender, tx.Receiver, tx.Amount);
            tx.IsFraud = fraud.IsFraud;
            tx.FraudScore = fraud.FraudScore;
            tx.FraudReason = fraud.FraudReason ?? "";

            await _context.SaveChangesAsync();

            TempData["Success"] = tx.IsFraud ? "Güncellendi (Şüpheli)!" : "Güncellendi (Normal).";
            return RedirectToAction(nameof(Index));
        }

        // GET: /Transactions/Delete/5
        [HttpGet]
        public async Task<IActionResult> Delete(int id)
        {
            if (!IsLoggedIn()) return RedirectToAction("Login", "Account");

            var tx = await _context.Transactions.FirstOrDefaultAsync(x => x.Id == id);
            if (tx == null) return NotFound();

            // Delete.cshtml @model Payment.Web.Models.Transaction olmalı
            return View(tx);
        }

        // POST: /Transactions/Delete/5  ✅ (405'i çözen kısım)
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            if (!IsLoggedIn()) return RedirectToAction("Login", "Account");

            var tx = await _context.Transactions.FirstOrDefaultAsync(x => x.Id == id);
            if (tx == null) return NotFound();

            _context.Transactions.Remove(tx);
            await _context.SaveChangesAsync();

            TempData["Success"] = "İşlem silindi.";
            return RedirectToAction(nameof(Index));
        }
    }
}
