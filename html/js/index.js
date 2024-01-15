document.addEventListener("DOMContentLoaded", function() {
    let body = document.getElementById('body');
    body.style.display = 'none';

    window.addEventListener("message", function(event) {
        let data = event.data;
        let pin_carta = document.getElementById('carta');
        let movimenti = document.getElementById('movimenti');
        let deposita = document.getElementById('deposita');
        let bonifico = document.getElementById('bonifico');
        let preleva = document.getElementById('preleva');
        let servizis = document.getElementById('servizis');
        let contos = document.getElementById('contos');

        function resetHTML() {
            body.style.display = 'none';
            contos.style.display = 'none';
            servizis.style.display = 'none';
            pin_carta.style.display = 'none';
            movimenti.style.display = 'none';
        }

        if (data.soldi) {
            let saldo = data.soldi
            saldo_banca = document.getElementById('saldo-banca').innerText = saldo
        }
        if (data.movimenti === true) {
            Movimenti(data.data);
        }
        if (data.apri === true) {
            resetHTML();
            body.style.display = 'block';
            contos.style.display = 'block';
            servizis.style.display = 'block'
            pin_carta.style.display = 'flex';
            movimenti.style.display = 'block';
        } 
        if (data.apri === false) {
            resetHTML();
        }
        if (data.atm == true) {
            resetHTML();
            body.style.display = 'block';
            preleva.style.display = 'flex';
            deposita.style.display = 'none';
            bonifico.style.display = 'none';
        } 
    });
});

function preleva() {
    let prelevai = document.getElementById('prelevai')
    let quantita = prelevai.value
    $.post("https://Zeta_bank/preleva", JSON.stringify({ quantita: quantita }));
    // console.log(quantita)// debug
    prelevai.value = '';
}

function deposita() {
    let deposita = document.getElementById('depositai')
    let quantita = deposita.value
    $.post("https://Zeta_bank/deposita", JSON.stringify({ quantita: quantita }));
    deposita.value = '';
}

function invia_bonifico() {
    let input = document.getElementById('bonificoi');
    let id = document.getElementById('bonificoid');
    let quantita = input.value;
    let id_giocatore = id.value;

    $.post("https://Zeta_bank/bonifico", JSON.stringify({ quantita: quantita, id_giocatore: id_giocatore }));
    
    input.value = '';
    id.value = '';
}

function Richiedi_cartadicredito() {
    $.post("https://Zeta_bank/richiedicarta", JSON.stringify({}));
}

function Movimenti(data) {
    let movDiv = document.getElementById('mov');

    movDiv.innerHTML = '';

    if (data && data.length > 0) {
        for (let i = 0; i < data.length; i++) {

            let iconSpan = document.createElement('span');
            iconSpan.className = 'icon';
            if (data[i].type == "withdraw") {
                iconSpan.innerHTML = '<i class="fa fa-chevron-down"></i> ';
                let movimentoText = document.createTextNode('Withdraw' + ' - ');
            
                // Creazione di un elemento <span> per l'importo con colore verde
                let amountSpan = document.createElement('span');
                amountSpan.style.color = 'red';
                amountSpan.textContent = data[i].amount + '$';
            
                let movimentoParagraph = document.createElement('p');
                movimentoParagraph.appendChild(iconSpan);
                movimentoParagraph.appendChild(movimentoText);
                movimentoParagraph.appendChild(amountSpan);
            
                movDiv.appendChild(movimentoParagraph);
            } else if (data[i].type == "deposited") {
                iconSpan.innerHTML = '<i class="fa fa-chevron-up"></i> ';
                let movimentoText = document.createTextNode('Deposited' + ' + ');
            
                // Creazione di un elemento <span> per l'importo con colore verde
                let amountSpan = document.createElement('span');
                amountSpan.style.color = 'green';
                amountSpan.textContent = data[i].amount + '$';
            
                let movimentoParagraph = document.createElement('p');
                movimentoParagraph.appendChild(iconSpan);
                movimentoParagraph.appendChild(movimentoText);
                movimentoParagraph.appendChild(amountSpan);
            
                movDiv.appendChild(movimentoParagraph);
            } else if (data[i].type == "transfer") {
                iconSpan.innerHTML = '<i class="fa fa-exchange"></i> ';
                let movimentoText = document.createTextNode('Transfer' + ' - ');
            
                // Creazione di un elemento <span> per l'importo con colore verde
                let amountSpan = document.createElement('span');
                amountSpan.style.color = 'red';
                amountSpan.textContent = data[i].amount + '$';
            
                let movimentoParagraph = document.createElement('p');
                movimentoParagraph.appendChild(iconSpan);
                movimentoParagraph.appendChild(movimentoText);
                movimentoParagraph.appendChild(amountSpan);
            
                movDiv.appendChild(movimentoParagraph);
            }
            
        }
    } else {
        movDiv.textContent = 'Nessun Movimento';
    }
}





function conto() {
    let pin_carta = document.getElementById('carta');
    let movimenti = document.getElementById('movimenti');
    let deposita = document.getElementById('deposita')
    let preleva = document.getElementById('preleva')
    let bonifico = document.getElementById('bonifico')
    let backcont = document.getElementById('backcont')
    let backserv = document.getElementById('backserv')
    if (pin_carta.style.display == 'none' || pin_carta.style.display == '') {
        pin_carta.style.display = 'flex';
        movimenti.style.top = '300px';
        movimenti.style.left = '250px';
        movimenti.style.transition = 'all .3s';
        bonifico.style.display = 'none';
        deposita.style.display = 'none';
        preleva.style.display = 'none';
        backcont.style.background = '';
        backserv.style.background = 'transparent';
    }
}

function servizi() {
    let pin_carta = document.getElementById('carta');
    let movimenti = document.getElementById('movimenti');
    let deposita = document.getElementById('deposita')
    let preleva = document.getElementById('preleva')
    let bonifico = document.getElementById('bonifico')
    let backcont = document.getElementById('backcont')
    let backserv = document.getElementById('backserv')
    if (pin_carta.style.display == 'flex' || pin_carta.style.display == '') {
        pin_carta.style.display = 'none';
        movimenti.style.top = '525px';
        movimenti.style.left = '632px';
        movimenti.style.transition = 'all .3s';
        bonifico.style.display = 'flex';
        deposita.style.display = 'flex';
        preleva.style.display = 'flex';
        backcont.style.background = 'transparent';
        backserv.style.background = 'rgba(0, 255, 255, 0.5)';
    }
}

function esci() {
    $.post("https://Zeta_bank/chiudiBanca", JSON.stringify({}));
}

