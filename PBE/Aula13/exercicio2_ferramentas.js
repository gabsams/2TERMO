const entrada = require('readline-sync');
const fs = require('fs');

ferramenta = [];
const ferramentas = entrada.questionInt("Digite quantas ferramentars serão registradas: ");
for (let i = 0; i < ferramentas; i++){
    const nome = entrada.question("Digite o nome da ferramenta: ");
    const quantidade = entrada.questionInt("Digite a quantidade: ");
    const custoUnitario = entrada.questionFloat("Digite o preço unitario: ")
    ferramenta.push({nome,quantidade,custoUnitario})
}

const registroferramentas = JSON.stringify(ferramenta, null, 2);
const arquivo = "ferramentas.json";
fs.writeFileSync(arquivo, registroferramentas);

console.log("\nRegistro concluido com sucesso! ");
console.log(`Verifique o arquivo'${arquivo}'`);
