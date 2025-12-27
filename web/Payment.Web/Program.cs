using Microsoft.EntityFrameworkCore;
using Payment.Web.Data;
using Payment.Web.Services;

var builder = WebApplication.CreateBuilder(args);

// =====================
// MVC
// =====================
builder.Services.AddControllersWithViews();

// =====================
// Session & HttpContext
// =====================
builder.Services.AddHttpContextAccessor();

builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromMinutes(30);
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
});

// =====================
// Database (MySQL)
// =====================
builder.Services.AddDbContext<AppDbContext>(options =>
{
    options.UseMySql(
        builder.Configuration.GetConnectionString("DefaultConnection"),
        ServerVersion.AutoDetect(
            builder.Configuration.GetConnectionString("DefaultConnection")
        )
    );
});

// =====================
// Dependency Injection
// =====================
builder.Services.AddScoped<ITransactionService, TransactionService>();
builder.Services.AddScoped<INodeApiClient, NodeApiClient>();

// =====================
// HttpClient (Node API)
// =====================
builder.Services.AddHttpClient<NodeApiClient>(client =>
{
    client.BaseAddress = new Uri("http://localhost:3001");
});

var app = builder.Build();

// =====================
// Middleware
// =====================
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
}

app.UseStaticFiles();
app.UseRouting();

app.UseSession();

app.UseAuthorization();

// =====================
// Routing
// =====================
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Account}/{action=Login}/{id?}");

app.Run();
