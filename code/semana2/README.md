# Semana 2

## Criação do estado preparação

Estado para zerar todos os sinais necessários e servir como
estado de início de cada nova rodada.

## Alternância de jogador

Dois sinais, um para o Jogador1 e outro para o Jogador2, deverão acender
indicando quem é o jogador da rodada. A cada jogada macro e micro feita, o 
jogador atual é trocado e o próximo deve jogar.

## Não Jogar em células macro vencidas

Quando a jogada micro for feita, se seu quadrante corresponder ao quadrante macro de uma célula vencida, o próximo jogador pode escolher a jogada macro. Caso não seja de uma célula vencida, o próximo jogador é obrigado a jogar nela e deve escolher somente a célula micro.

## Jogar na célula macro correspondente à última micro jogada

Quando o jogador jogar em uma célula micro do quadrante X, a jogada macro do próximo jogador será automaticamente esse quadrante X, caso válido (vide regra acima).
