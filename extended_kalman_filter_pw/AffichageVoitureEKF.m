   % AFFICHAGE DE LA VOITURE
   
   pos_v_x = VehiculeNL.X_E(1);
   pos_v_y = VehiculeNL.X_E(2);
   angle_vehicule = VehiculeNL.X_E(3);
   P_E_I = VehiculeNL.P_E(1:2,1:2);

   %========================================
   % AFFICHAGE DU VEHICULE ET DES CAPTEURS
   %========================================
  
      
      % CARACTERISTIQUE DU VEHICULE 
	    %==============================================
		% l'angle et la position de notre véhicule dans 
		% le repere absolu
		%==============================================

        VehiculeRoues = struct( 'x_en_ravh',[],'y_en_ravh',[],...
                                'x_en_ravb',[],'y_en_ravb',[],...
                                'x_en_rarh',[],'y_en_rarh',[],...
                                'x_en_rarb',[],'y_en_rarb',[]);
        
        VehiculeCaisse = struct('x_en',[],'y_en',[],...
                                'x_en_cav',[],'y_en_cav',[],...
                                'x_en_car',[],'y_en_car',[],...
                                'x_en_pavb',[],'y_en_pavb',[],...
                                'x_en_pavh',[],'y_en_pavh',[]);
        
        VehiculeVitres = struct('x_en_va',[],'y_en_va',[],...
                                'x_en_vb',[],'y_en_vb',[],...
                                'x_en_vh',[],'y_en_vh',[],...
                                'x_en_avb',[],'y_en_avb',[],...
                                'x_en_avh',[],'y_en_avh',[],...
                                'x_en_var',[],'y_en_var',[]);
        
      [VehiculeRoues,VehiculeCaisse,VehiculeVitres] =  ModeleVoiture(angle_vehicule,[pos_v_x pos_v_y],VehiculeRoues,VehiculeCaisse,VehiculeVitres); 

      % Affichage du vehicule
      %=======================
      % affichage des roues
      fill(VehiculeRoues.x_en_ravh,VehiculeRoues.y_en_ravh,[.5 .5 .5]);
      fill(VehiculeRoues.x_en_ravb,VehiculeRoues.y_en_ravb,[.5 .5 .5]);
      fill(VehiculeRoues.x_en_rarh,VehiculeRoues.y_en_rarh,[.5 .5 .5]);
      fill(VehiculeRoues.x_en_rarb,VehiculeRoues.y_en_rarb,[.5 .5 .5]);
      
      % affichage de la caisse (bleu)
      fill(VehiculeCaisse.x_en,VehiculeCaisse.y_en,[.7 0 0 ]);
      
      % affichage du capot avant
      fill(VehiculeCaisse.x_en_cav,VehiculeCaisse.y_en_cav,[0.75 0 0 ]);
		% affichage du capot arrière
      fill(VehiculeCaisse.x_en_car,VehiculeCaisse.y_en_car,[0.75 0 0 ]);
      
      % affichage du phare avant bas
      fill(VehiculeCaisse.x_en_pavb,VehiculeCaisse.y_en_pavb,[.8 .75 0]);
		% affichage du phare avant haut
      fill(VehiculeCaisse.x_en_pavh,VehiculeCaisse.y_en_pavh,[.8 .75 0]);
      
      % affichage des vitres
      fill(VehiculeVitres.x_en_va,VehiculeVitres.y_en_va,[.8 .9 .8]);
      fill(VehiculeVitres.x_en_vb,VehiculeVitres.y_en_vb,[.8 .9 .8]);
      fill(VehiculeVitres.x_en_vh,VehiculeVitres.y_en_vh,[.8 .9 .8]);
      fill(VehiculeVitres.x_en_avb,VehiculeVitres.y_en_avb,[.8 .9 .8]);
      fill(VehiculeVitres.x_en_avh,VehiculeVitres.y_en_avh,[.8 .9 .8]);
      fill(VehiculeVitres.x_en_var,VehiculeVitres.y_en_var,[.8 .9 .8]);
      
      DrawEllipse([pos_v_x pos_v_y],P_E_I,'r',1);
      
      % affichage du cap du véhicule
		%==============================
		Variance_cap=sqrt(VehiculeNL.P_E(3,3));
		Cap=VehiculeNL.X_E(3);
		Cap_Max=Cap+Variance_cap;
		Cap_Min=Cap-Variance_cap;
		X_cap_min=[cos(Cap_Min) -sin(Cap_Min); sin(Cap_Min) cos(Cap_Min)]*[2;0]+VehiculeNL.X_E(1:2);
		X_cap_max=[cos(Cap_Max) -sin(Cap_Max); sin(Cap_Max) cos(Cap_Max)]*[2;0]+VehiculeNL.X_E(1:2);
		X_cap=[cos(Cap) -sin(Cap); sin(Cap) cos(Cap)]*[2;0]+VehiculeNL.X_E(1:2);

		hndl=plot([VehiculeNL.X_E(1) X_cap_min(1)],[VehiculeNL.X_E(2) X_cap_min(2)],'y');
		hndl=plot([VehiculeNL.X_E(1) X_cap_max(1)],[VehiculeNL.X_E(2) X_cap_max(2)],'y');
		hndl=plot([VehiculeNL.X_E(1) X_cap(1)],[VehiculeNL.X_E(2) X_cap(2)],'y');





