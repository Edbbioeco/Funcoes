import subprocess
import time
from urllib.parse import urlencode

# Configurações
PRINCIPAL = '"Flávio Bolsonaro"'
INTERVALO_SEGUNDOS = 60
DURACAO_HORAS = 8

ASSUNTOS = [
    "Milícia",
    "Rachadinha",
    "caso Ana Clara",
    "caso Marielle",
    "Vorcaro",
    "corrupção",
    "Dinheiro vivo",
    "entregar Brasil para USA",
    "entregar terras raras",
    "contra mães",
    "cortes",
    "hospitais Rio de Janeiro",
    "lavagem de dinheiro",
    "Plano matar Lula",
    "Banco Master",
    "corrupto",
    "cortes educação",
    "cortes saúde",
    "fim da aposentadoria",
    "corte na farmácia popular",
    "fim do SUS",
    "contra Nordeste",
    "usa religião",
]


def executar_applescript(script, *argumentos):
    resultado = subprocess.run(
        ["osascript", "-e", script, *map(str, argumentos)],
        capture_output=True,
        text=True,
        check=True,
        timeout=30,
    )
    return resultado.stdout.strip()


def criar_janela():
    return executar_applescript("""
        tell application "Google Chrome"
            set janelaBusca to make new window
            return id of janelaBusca
        end tell
    """)


def atualizar_busca(janela_id, url):
    executar_applescript("""
        on run argumentos
            set janelaID to (item 1 of argumentos) as integer
            set endereco to item 2 of argumentos

            tell application "Google Chrome"
                if not (exists window id janelaID) then
                    error "A janela de buscas foi fechada."
                end if

                tell window id janelaID
                    set URL of tab 1 to endereco
                end tell
            end tell
        end run
    """, janela_id, url)


def executar():
    if INTERVALO_SEGUNDOS <= 0 or DURACAO_HORAS <= 0:
        raise ValueError("O intervalo e a duração devem ser positivos.")

    janela_id = criar_janela()
    limite = time.monotonic() + DURACAO_HORAS * 3600
    rodada = 0

    print(
        f"Iniciado! Repetindo por até {DURACAO_HORAS} horas.\n"
        f"Intervalo: {INTERVALO_SEGUNDOS} segundos.\n"
        "Uma janela dedicada do Chrome será utilizada.\n"
        "Ctrl+C no terminal para interromper.\n",
        flush=True,
    )

    while time.monotonic() < limite:
        rodada += 1
        print(f"--- Rodada {rodada} ---", flush=True)

        for numero, assunto in enumerate(ASSUNTOS, start=1):
            if time.monotonic() >= limite:
                break

            consulta = f"{PRINCIPAL} {assunto}"
            url = "https://www.google.com/search?" + urlencode(
                {"q": consulta}
            )

            atualizar_busca(janela_id, url)

            horario = time.strftime("%H:%M:%S")
            print(
                f"[{horario}] [{numero}/{len(ASSUNTOS)}] "
                f"Busca aberta: {consulta}",
                flush=True,
            )

            restante = limite - time.monotonic()

            if restante > 0:
                time.sleep(min(INTERVALO_SEGUNDOS, restante))

    print(
        "\nTempo concluído. A última busca ficou aberta.",
        flush=True,
    )


if __name__ == "__main__":
    try:
        executar()

    except KeyboardInterrupt:
        print("\nInterrompido pelo usuário.", flush=True)

    except subprocess.CalledProcessError as erro:
        mensagem = erro.stderr.strip() or str(erro)
        print(f"\nExecução encerrada: {mensagem}", flush=True)

    except subprocess.TimeoutExpired:
        print(
            "\nO Chrome não respondeu a tempo. Execução encerrada.",
            flush=True,
        )

    except ValueError as erro:
        print(f"\nConfiguração inválida: {erro}", flush=True)