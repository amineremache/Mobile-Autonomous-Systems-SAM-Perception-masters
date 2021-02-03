function Dec = Decision (M_data)

%% Probleme a Deux classes 
if (size(M_data,3)==4) 

    nb_classes = 2; 
    BetP_erd = zeros(size(M_data,1), size(M_data,2), nb_classes);
    
    %% Calcul de BetP
    % Rappel Def : BetP(omega) = somme ( m(A)/|A| ) pour tout A tel que omega appartient à A.
    
    BetP_erd(:,:,1) = M_data(:,:,1) + M_data(:,:,3)/nb_classes;%%
    BetP_erd(:,:,2) = M_data(:,:,2) + M_data(:,:,3)/nb_classes;%%

    
    %% Resultat de classification
    % Le maximum de BetP donne la classe    
    Dec = max(BetP_erd(:,:,1),BetP_erd(:,:,2));%%
end


%% Probleme à trois classes 

if (size(M_data,3)==8)
    
    %% Calcul de BetP
    Bet = calcul_BetP3classes(M_data); % completez dans la fonction  Ou voir calcul_BetP pour le cas général.
    
    %% Resultat de Classification 
    
    % Version 1
    Dec = 2*(Bet(:,:,3)>Bet(:,:,2)).*(Bet(:,:,3)>Bet(:,:,1)) +...
        (Bet(:,:,2)>Bet(:,:,1)).*(Bet(:,:,2)>Bet(:,:,3)) +...
        1;
    
    % Version 2
%     max_BetP_erd = max(BetP_erd,[],3);
%     
%     Dec= zeros(size(Im1));
%     
%     Dec(BetP_erd(:,:,1) == max_BetP_erd) = 1;
%     Dec(BetP_erd(:,:,2) == max_BetP_erd) = 2;
%     Dec(BetP_erd(:,:,3) == max_BetP_erd) = 3;
    
    
end


