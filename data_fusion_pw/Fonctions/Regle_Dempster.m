function I_conj = Regle_Dempster(I1,I2)

I_conj = zeros(size(I1,1),size(I1,2),size(I1,3));

% vecteur element focaux
EltF_ok=zeros(size(I1,3),2);
for i=1:size(I1,3)
    if sum(sum(I1(:,:,i))) >0
        EltF_ok(i,1) = 1;
    end
    if sum(sum(I2(:,:,i))) >0
        EltF_ok(i,2) = 1;
    end
end


% regle conjonctive sans normalisation
for i=1:size(I1,3)
    for j=1:size(I1,3)
            % ******************************
            % **** début compléter *********
            
            % Prendre la forme binaire 
            B=dec2bin(mod(i,size(I1,3)),log2(size(I1,3))); 
            C=dec2bin(mod(j,size(I1,3)),log2(size(I1,3)));
            
            % Prendre l'intersection binaire entre B et C
            intersection = bitand(str2num(B(:)),str2num(C(:)));
            intersection_index = bin2dec(num2str(intersection)');
            
            % Pour l'élément vide, l'index est sur la dernière colonne et
            % ne suit pas la logique précédente
            if intersection_index == 0
                intersection_index = size(I1,3);
            end
            
            % Rajouter le produit de masses de m1(B) et m2(C) 
            I_conj(:,:,intersection_index) = I_conj(:,:,intersection_index) + I1(:,:,i).*I2(:,:,j);

            % **** Fin compléter ***********
            % ******************************
    end
end

