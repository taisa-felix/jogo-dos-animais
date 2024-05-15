:- dynamic pergunta_esquerda_sim/2.
:- dynamic pergunta_direita_nao/2.
:- dynamic animal_esquerda_sim/2.
:- dynamic animal_direita_nao/2.
:- dynamic raiz/1.

% Inicia o jogo
inicio :-
    write("Bem-vindo ao jogo dos animais. Vou tentar adivinhar qual animal voce esta pensando."),
    nl,
    jogar(raiz).

% Predicado para jogar uma rodada do jogo
jogar(Pergunta) :-
    pergunta(Pergunta, Resposta),
    proximo_passo(Resposta, Pergunta, Proximo),
    jogar(Proximo).

% Predicado para fazer uma pergunta ao usuário e obter a resposta
pergunta(Pergunta, Resposta) :-
    write(Pergunta), write(' (s/n): '),
    read(Resposta),
    nl.

% Predicado para determinar o próximo passo com base na resposta do usuário
proximo_passo(s, Pergunta, Proximo) :-
    (
        pergunta_esquerda_sim(Pergunta, Proximo) ;
        (eh_folha(Pergunta), animal_esquerda_sim(Pergunta, Proximo))
    ).

proximo_passo(n, Pergunta, Proximo) :-
    pergunta_direita_nao(Pergunta, Proximo).

% Predicado para verificar se um nó é uma folha
eh_folha(No) :-
    not(pergunta_esquerda_sim(No, _)),
    not(pergunta_direita_nao(No, _)).

% Iniciar o jogo
:- initialization(inicio).
