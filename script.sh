#!/bin/bash
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'
csv_file=""

creare_fisier(){
   echo -e "${BLUE}Ati selectat optiunea 1 : creeaza fisier de tip CSV${NC}"
   read -p "Introduceti numele fisierului de tip CSV pe care doriti sa il creati: " csv_file
   if [ -f "$csv_file" ]
   then
        echo -e "${RED}Fisierul $csv_file deja exista si a fost selectat!${NC}"
   else
        echo "Id,nume,varsta,salariu,rol,email" > "$csv_file"
        echo -e "${RED} Fisierul $csv_file a fost creat cu succes${NC}"
   fi
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

adauga_inregistrare(){

        if [ ! -f "$csv_file" ]; then
            echo -e "${RED}Fisierul nu exista.${NC}"
            return
        fi


  echo "Ati seletat optiunea 2:Adauga inregistrare"

  nume=""
  varsta=""
  salariu=""
  rol=""
  email=""

#validare nume

   while true; do

        read -p "Introduceti numele:" nume
        if echo "$nume" | grep -Eq "^[a-zA-Z ]+$";then
           break
        else
           echo -e "${RED}Numele este invalid!Introduceti doar litere.${NC}"
        fi

 done


#validare varsta

   while true; do

        read -p "Introduceti varsta:" varsta
        if echo "$varsta" | grep -Eq "^[0-9]+$" && [ "$varsta" -gt 17 ] && [ "$varsta" -lt 61 ]; then
             break
          else
             echo -e "${RED}Varsta invalida!Trebuie sa introduceti o valoare mai mare decat 18 si mai mica decat 60${NC}"
          fi

   done

#validare salariu

   while true; do

        read -p "Introduceti salariul:" salariu
        if echo "$salariu" | grep -Eq "^[0-9]+$" && [ "$salariu" -gt 999 ];then
             break
          else
             echo -e "${RED}Salariu invalid!Salariul minim este de 1000\$${NC}"
          fi
   done


#validare rol

   while true; do

        read -p "Introduceti rolul pe care il detine angajatul: " rol
        if echo "$rol" | grep -Eq "^(Front-end|Back-end|Full-stack|DevOps)$";then
           break
        else
           echo -e "${RED}Rol invalid!Optiunile valide sunt : 'Front-end', 'Back-end', 'Full-stack', 'DevOps'${NC}"
        fi
   done
#validare email
         while true; do
    read -p "Introduceti adresa de email: " email
    if echo "$email" | grep -Eq "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"; then
      break
    else
   echo "Adresa de email invalida. Va rugam introduceti alta adresa ."
    fi
  done

 id=$(( $(tail -n 1 "$csv_file" | cut -d "," -f 1) + 1 ))
 echo "$id,$nume,$varsta,$salariu,$rol,$email" >> "$csv_file"
 echo -e "${RED}Inregistrarea cu ID-ul $id a fost adaugata cu succes!${NC}"
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


sterge_inregistrare(){

        if [ ! -f "$csv_file" ]; then
            echo -e "${RED}Fisierul nu exista.${NC}"
            return
        fi

        echo -e "${RED}Ati selectat optiunea 3:Sterge inregistrare${NC}"
        read -p "Introduceti id-ul inregistratii pe care doriti sa o stergeti:" d_id

        if ! grep -q "^$d_id," "$csv_file"; then # -q silent mode, nu produce output , dar exit statusul determina rezultatu
          echo -e "${RED}Inregistrarea cu id-ul $d_id nu exista.${NC}"
          return
        fi

        sed -i "/^$d_id.*/d; /^$/d" "$csv_file"
        echo -e "${RED}Inregistrarea cu id-ul $d_id a fost stearsa cu succes!${NC}"
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sort_menu(){

        echo "Selectati campul dupa care doriti sortarea: "
        echo "1.Nume"
        echo "2.Varsta"
        echo "3.Salariu"
}

sort_nume(){

        echo -e "${RED}~~~~Sortare dupa nume~~~~${NC}"
        sortat=$(tail -n +2 "$csv_file" | sort -t',' -k2 -f)

        read -p "Salvati datele sortate in alt fisier?[Y/N]: " option

        case $option in
           [Yy])
              read -p "Introduceti numele fisierului:" sorted_file
              echo "$sortat" > "$sorted_file"
              echo -e "${RED}Datele au fost salvate cu succes in fisierul $sorted_file${NC}"
            ;;
           [Nn])
              echo "$sortat";;
           *) echo -e "${RED}Optiune invalida.${NC}"
           return
           ;;
        esac
}

sort_varsta(){

   sortat=$(tail -n +2 "$csv_file" | sort -t',' -k3 -n)

   read -p "Salvati datele sortate in alt fisier?[Y/N]: " option

   case $option in
        [Yy])
           read -p "Introduceti numele fisierului: " sorted_file
           echo "$sortat" > "$sorted_file"
           echo -e "${RED}Datele au fost salvate cu succes in $sorted_file${NC}"
          ;;
        [Nn])
          echo "$sortat"
          ;;
        *)echo -e "${RED}Optiune invalida.${NC}"
        return
          ;;
   esac
}

sort_varsta_mai_mare_sau_egal(){

read -p "Introduceti varsta minima: " age

sortat=$(tail -n +2 "$csv_file" | awk -F',' -v age="$age" '$3 >= age')
read -p "Salvati datele sortate in alt fisier?[Y/N]: " option

   case $option in

      [Yy])
        read -p "Introduceti numele fisierului: " sorted_file
        echo "$sortat" > "$sorted_file"
        echo -e "${RED}Datele au fost salvate cu succes in $sorted_file${NC}"
        ;;
        [Nn])
        echo "$sortat"
        ;;
        *)
        echo -e "${RED}Optiune invalida.${NC} "
        return
        ;;
   esac
}

sort_salariu(){

        echo -e "${RED}~~~~Sortare dupa salariu~~~~${NC}"
        echo "1.Sortare crescatoare"
        echo "2.Sortare dupa o valoare minima"

        read -p "Introduceti optiunea: " optiune

        case $optiune in 
           1)
             sortat=$(tail -n +2 "$csv_file" | sort -t ',' -k4 -n)
           ;;
           2)
             read -p "Introduceti salariul minim: " salariu
             sortat=$(tail -n +2 "$csv_file" | awk -F ',' -v OFS=',' -v salariu="$salariu" '$4 >= $salariu')
           ;;
           *)echo -e"${RED}Optiune invalida!${NC}"
             return;;
        esac

        read -p "Salvati datele sortate in alt fisier?[Y/N]" optiune

        case $optiune in 
            [Yy])
           read -p "Introduceti numele fisierului: " sorted_file
           echo "$sortat" > "$sorted_file"
           echo -e "${RED}Datele au fost salvate in $sorted_file!${NC}"
             ;;
            [Nn])
           echo "$sortat"
      	     ;;
            *)
                echo -e "${RED}Optiune invalida!${NC}"
                return
             ;;
        esac
}

sortare(){

        if [ ! -f "$csv_file" ]; then
            echo -e "${RED}Fisierul nu exista.${NC}"
            return
        fi

        echo -e "${RED}Ati selectat optiunea 4:Sortare${NC}"

        sort_menu

        read -p "Alegeti criteriul de sortare dorit: " nr

        case $nr in
          1)
            sort_nume
          ;;
          2)
        echo -e "${RED}~~~~Sortare dupa varsta~~~~${NC}"
            echo "1.Sortare crescatoare"
            echo "2.Sortare dupa o varsta minima"
        read -p "Alegeti o optiune: " optiune

        case $optiune in
            1) sort_varsta;;
            2) sort_varsta_mai_mare_sau_egal;;
        esac
          ;;
          3)
                sort_salariu
          ;;
        esac

}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
actualizare_inregistrare(){

        if [ ! -f "$csv_file" ]; then
            echo -e "${RED}Fisierul nu exista.${NC}"
            return
        fi

        echo -e "${RED}Ati selectat optiunea 5:Actualizare inregistrare${NC}"

        read -p "Introduceti ID-ul inregistrarii pe care doriti sa o actualizati: " id

        if ! grep -q "^$id" "$csv_file"; then
           echo "Inregistrarea nu exista!"
        return
        fi

        read -p "Datele pe care le puteti actualiza sunt urmatoarele:
1.Nume
2.Varsta
3.Salariu
4.Rol
5.Email
Introduceti NUMELE campului pe care doriti sa il actualizati: " optiune

        touch temp.csv
        case $optiune in 
        [Nn]ume)

#validare nume

   while true; do

        read -p "Introduceti numele nou: " nume
        if echo $nume | grep -Eq "^[a-zA-Z ]+$";then
           break
        else
           echo -e "${RED}Numele este invalid!Introduceti doar litere.${NC}"
        fi
   done

        awk -F',' -v OFS=',' -v nume_nou="$nume" -v id="$id" 'id == $1 { $2 = nume_nou } {print}' "$csv_file" >  "temp.csv"
        ;;
        [Vv]arsta)

#validare varsta

while true; do

        read -p "Introduceti varsta noua: " varsta
        if echo $varsta | grep -Eq "^[0-9]+$" && [ $varsta -gt 17 ] && [ $varsta -lt 61 ]; then
             break
          else
             echo -e "${RED}Varsta invalida!Trebuie sa introduceti o valoare mai mare decat 18 si mai mica decat 60${NC}"
          fi

   done

        awk -F ',' -v OFS=',' -v varsta_noua="$varsta" -v id="$id" 'id == $1 { $3 = varsta_noua } {print}' "$csv_file" > "temp.csv"
        ;;
        [Ss]alariu)

#validare salariu

   while true; do

        read -p "Introduceti salariul nou: " salariu
        if echo $salariu | grep -Eq "^[0-9]+$" && [ $salariu -gt 999 ];then
             break
          else
             echo -e "${RED}Salariu invalid!Salariul minim este de 1000\$${NC}"
          fi
   done

        awk -F ',' -v OFS=',' -v salariu_nou="$salariu" -v id="$id" 'id == $1 { $4 = salariu_nou } {print}' "$csv_file" > "temp.csv"
        ;;
        [Rr]ol)

#validare rol

   while true; do

        read -p "Introduceti noul rol: " rol
        if echo $rol | grep -Eq "^(Front-end|Back-end|Full-stack|DevOps)$";then
           break
        else
           echo -e "${RED}Rol invalid!Optiunile valide sunt : 'Front-end', 'Back-end', 'Full-stack', 'DevOps'${NC}"
        fi
   done

        awk -F ',' -v OFS=',' -v rol_nou="$rol" -v id="$id" 'id == $1 { $5 = rol_nou } {print}' "$csv_file" > "temp.csv"
        ;;
        [Ee]mail)

#validare email
         while true; do
    read -p "Introduceti noua adresa de email: " email
    if echo "$email" | grep -Eq "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"; then
      break
    else
      echo "Adresa de email invalida. Va rugam introduceti alta adresa ."
    fi
  done

        awk -F ',' -v OFS=',' -v email_nou="$email" -v id="$id" 'id == $1 { $6 = email_nou } {print}' "$csv_file" > temp.csv
        ;;
        *)
        echo -e "${RED}Optiune invalida!${NC}"
        return
        ;;
        esac

        mv "temp.csv" "$csv_file"
        echo -e "${RED}Inregistrarea cu ID-ul $id a fost actualizata cu succes!${NC}"

        read -p "Doriti sa faceti alte modificari?[Y/N] " optiune

        case $optiune in
            [Yy])actualizare_inregistrare;;
            [Nn])return;;
            *)echo -e "${RED}Optiune invalida!Intoarcere catre meniul principal...${NC}"
              return;;
        esac
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
while true; do
    echo -e "${BLUE}======================MENIU======================${NC}"
    echo "1.Creeaza fisier de tip CSV/Selectare fisier CSV"
    echo "2.Adauga inregistrare"
    echo "3.Sterge inregistrare"
    echo "4.Sortare"
    echo "5.Actualizare inregistrare"
    echo "6.Iesire"

  read -p "Alegeti o optiune:" optiune

  case $optiune in
        1)creare_fisier
          sleep 1;;
        2)adauga_inregistrare
          sleep 1;;
        3)sterge_inregistrare
          sleep 1;;
        4)sortare
          sleep 1;;
        5)actualizare_inregistrare
          sleep 1;;
        6)break;;
        *)echo -e "${RED} Optiune invalida.Incearca din nou.${NC}";;
esac

done