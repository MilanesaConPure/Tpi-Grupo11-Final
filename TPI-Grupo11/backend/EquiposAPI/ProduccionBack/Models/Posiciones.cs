﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace ProduccionBack.Models;

public partial class Posiciones
{
    public int IdPosicion { get; set; }

    public string Posicion { get; set; }
    [JsonIgnore]
    public virtual ICollection<Jugadores> Jugadores { get; set; } = new List<Jugadores>();
    [JsonIgnore]
    public virtual ICollection<JugadoresLog> JugadoresLogs { get; set; } = new List<JugadoresLog>();
}