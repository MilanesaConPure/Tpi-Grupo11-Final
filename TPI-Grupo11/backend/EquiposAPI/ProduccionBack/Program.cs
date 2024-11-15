using Microsoft.OpenApi.Models;
using ProduccionBack.Repositories.Usuarios;
using ProduccionBack.Repositories.Equipos;
using ProduccionBack.Repositories.Jugadores;
using ProduccionBack.Repositories.Posiciones;
using ProduccionBack.Repositories.Personas;
using ProduccionBack.Repositories.Jwt;
using Microsoft.EntityFrameworkCore;
using ProduccionBack.Models;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using ProduccionBack.Repositories.Ligas;
using ProduccionBack.Repositories.EquiposLigasInfo;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.RequireHttpsMetadata = false;  // Solo en desarrollo
        options.SaveToken = true;
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = builder.Configuration["Jwt:Issuer"],  // Puedes definir estas configuraciones en appsettings.json
            ValidAudience = builder.Configuration["Jwt:Audience"],
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(builder.Configuration["Jwt:Key"]))  // Aquí defines la clave secreta
        };
    });

builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new Microsoft.OpenApi.Models.OpenApiInfo { Title = "Los Vietnamitas trabajando", Version = "v1" });

    c.AddSecurityDefinition("Bearer", new Microsoft.OpenApi.Models.OpenApiSecurityScheme
    {
        Description = "Jwt Authentication",
        Name = "Authorization",
        In = Microsoft.OpenApi.Models.ParameterLocation.Header,
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.ApiKey,
        Scheme = "Bearer"
    });

    c.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            new string[] { }
        }
    });
});

builder.Services.AddCors(options =>
{
    options.AddPolicy("CORS",
        policy =>
        {
            policy.AllowAnyOrigin()
                  .AllowAnyMethod()
                  .AllowAnyHeader();
        });
});

builder.Services.AddDbContext<EquipoContext>(options => options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

builder.Services.AddScoped<IUsuariosRepositories, UsuariosRepositories>();
builder.Services.AddScoped<IEquiposRepository, EquiposRepository>();
builder.Services.AddScoped<IJugadoresRepository, JugadoresRepository>();
builder.Services.AddScoped<IPersonasRepository, PersonasRepository>();
builder.Services.AddScoped<IPosicionesRepository, PosicionesRepository>();
builder.Services.AddScoped<IJwtRepository, JwtRepository>();
builder.Services.AddScoped<ILigasRepository, LigasRepository>();
builder.Services.AddScoped<IEquiLigaInfoRepository, EquiLigaInfoRepository>();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.UseCors("CORS");

app.MapControllers();

app.Run();
