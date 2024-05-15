% Predicado dinâmico para representar a base de conhecimento
:- dynamic pergunta_esquerda_sim/2.
:- dynamic pergunta_direita_nao/2.

:- dynamic animal_esquerda_sim/2.
:- dynamic animal_direita_nao/2.

:- dynamic raiz/1.

% Definindo estrutura inicial das perguntas
raiz('Eh um mamifero?').
pergunta_esquerda_sim('Eh um mamifero?', 'Possui listras?').
pergunta_esquerda_sim('Eh um passaro?', 'Ele voa?').
pergunta_direita_nao('Eh um mamifero?', 'Eh um passaro?').

animal_esquerda_sim('Possui listras?', 'Eh uma zebra?').
animal_esquerda_sim('Ele voa?', 'Eh uma aguia?').

animal_direita_nao('Possui listras?', 'Eh um leao?').
animal_direita_nao('Ele voa?', 'Eh um pinguim?').
animal_direita_nao('Eh um passaro?', 'Eh um lagarto?').

% Predicado para jogar o jogo
jogar_jogo :-
    writeln('Pense em um animal e eu vou tentar adivinhar!'),
    jogar(raiz).

% Predicado para jogar uma rodada do jogo
jogar(Pergunta) :-
    pergunta(Pergunta, Resposta),
    animal_ou_pergunta(Resposta, Pergunta).

% Predicado para fazer uma pergunta ao usuário e obter a resposta
pergunta(Pergunta, Resposta) :-
    format('~w (sim/nao): ', [Pergunta]),
    read(Resposta),
    nl.

% Predicado para determinar se a resposta é um animal ou uma pergunta
animal_ou_pergunta(sim, Pergunta) :- 
    animal_esquerda_sim(Pergunta, Animal),
    !, adivinhar(Animal).

animal_ou_pergunta(sim, Pergunta) :- 
    animal_direita_nao(Pergunta, Animal),
    !, adivinhar(Animal).

animal_ou_pergunta(nao, Pergunta) :-
    pergunta_esquerda_sim(Pergunta, ProximaPergunta),
    jogar(ProximaPergunta).
    
animal_ou_pergunta(nao, Pergunta) :-
    pergunta_direita_nao(Pergunta, ProximaPergunta),
    jogar(ProximaPergunta).

% Predicado para adivinhar o animal
adivinhar(Animal) :-
    format('Eu acho que o animal eh um(a) ~w. Estou certo? (sim/nao): ', [Animal]),
    read(Resposta),
    (Resposta = sim, writeln('Eu ganhei! Obrigado por jogar.'); 
     Resposta = nao, aprender(Animal)).

% Predicado para aprender um novo animal
aprender(Animal) :-
    writeln('Que animal voce estava pensando?'),
    read(NovoAnimal),
    format('Qual pergunta distinguiria ~w de ~w? ', [NovoAnimal, Animal]),
    read(NovaPergunta),
    assertz(pergunta_esquerda_sim(NovaPergunta, NovoAnimal)),
    assertz(pergunta_direita_nao(NovaPergunta, Animal)),
    write('Obrigado! Agora eu aprendi mais um animal.'), nl,
    salvar_base_de_conhecimento,
    writeln('Obrigado por jogar!').

% Predicado para salvar a base de conhecimento em um arquivo
salvar_base_de_conhecimento :-
    tell('base_de_conhecimento.pl'),
    listing,
    told.

% Iniciar o jogo
:- initialization(jogar_jogo).
