const fs = require('fs');

console.log("===SISTEMA DE PERSISTENCIA: REGISTRO DE MAQUINAS===");

const maquinasIndustriais = [
    {id: 101, nome: "Torno Mecânico Universal", setor: "Usinagem", operacional: true},
    {id: 102, nome: "Fresadora Ferramenteira", setor: "Usinagem", operacional: false},
    {id: 103, nome: "Prensa Hidraulica 50T", setor: "Estamparia", operacional: true},
]

const dadosParaGravar = JSON.stringify(maquinasIndustriais, null, 2);
const nomeDoArquivo = "maquinas.json";

fs.writeFileSync(nomeDoArquivo,dadosParaGravar);

console.log(`\nGravacao concluida com sucesso.`);
console.log(`Verifique o arquivo '${nomeDoArquivo}'`);

