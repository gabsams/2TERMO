const fs = require('fs');

console.log("===SISTEMA DE MONITORAMENTO===");
const sensores = [
    {codigo: 1001, tipo:"Temperatura", leituraAtual: 40.8, status: "Operando"},
    {codigo: 1002, tipo:"Pressão", leituraAtual: 6, status: "Operando"},
    {codigo: 1001, tipo:"Temperatura", leituraAtual: 140.9, status: "Alerta!"}
]
const registrosSensor = JSON.stringify(sensores, null, 2);
const SensoresIndustriais = "registro.json";

fs.writeFileSync(SensoresIndustriais, registrosSensor);

console.log(`\nRegistro gravado com sucesso!`);
console.log(`Verifique o registro '${SensoresIndustriais}'`);