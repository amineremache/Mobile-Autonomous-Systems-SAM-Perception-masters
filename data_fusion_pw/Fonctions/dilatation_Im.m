function I_dil = dilatation_Im(Im,d, n)
nl = size(Im,1);
nc = size(Im,2);
nClass = size(Im,3);
I_dil=Im;

% Vecteur element focaux
EltF_ok=zeros(nClass);
for i=1:size(Im,3)
    if sum(sum(Im(:,:,i))) >0
        EltF_ok(i) = 1;
    end
end

% Dilatation

% Pour chaque iteration de dilatation
for o=1:n
    % Pour chaque classe 
    for k=1:size(Im,3)
        % Si élément focal 
        if EltF_ok(k) == 1
            
            % Application du filtre sur l'image
            for i=1:nl
                for j=1:nc
                    
                   I_dil(i,j,k) = max(max(Im(max(i-d,1):min(i+d,nl),max(j-d,1):min(j+d,nc),k))); 
                
                end
            end
            
        end
    end
    Im = I_dil;
end