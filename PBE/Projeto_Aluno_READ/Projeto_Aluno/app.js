// PROJETO DO ALUNO - complete as funções abaixo.
// Execute com: npm start
const fs = require('node:fs');
const caminho = require('node:path');
const ARQUIVO = caminho.join(__dirname, 'maquinas.json');

function carregarMaquinas() {
  const texto = fs.readFileSync(ARQUIVO, 'utf8');
  return JSON.parse(texto);
}

function listarMaquinas(maquinas) {
  maquinas.forEach(maquina => {
    console.log(`ID: ${maquina.id} | Nome: ${maquina.nome} | Status: ${maquina.status}`);
  });
}

function buscarPorId(maquinas, id) {
  return maquinas.find(m => m.id === Number(id));
}

function filtrarPorStatus(maquinas, status) {
  return maquinas.filter(m => m.status === status);
}

function filtrarPorSetor(maquinas, setor) {
  return maquinas.filter(m => m.setor === setor);
}

function executar() {
  console.log('Sistema de consultas industriais - CRUD READ\n');
 
  const maquinas = carregarMaquinas();
 
  console.log('--- Lista de Máquinas ---');
  listarMaquinas(maquinas);
}

if (require.main === module) executar();
module.exports = { carregarMaquinas, listarMaquinas, buscarPorId, filtrarPorStatus, filtrarPorSetor };