unit Pattern.Facade;

interface

type
  { Fa�ade }
  TFacade = class
  public
    // opera��o do Fa�ade
    procedure CalcularValorDeVenda (const Fidelidade: integer;
      const Preco: real);
  end;

implementation

uses
  SysUtils, Pattern.Subsystem.CotacaoDolar, Pattern.Subsystem.CalculoLoja,
  Pattern.Subsystem.Historico;

{ TFacade }

procedure TFacade.CalcularValorDeVenda (const Fidelidade: integer;
  const Preco: real);
var
  SubsystemCotacaoDolar: TSubsystemCotacaoDolar;
  SubsystemCalculoLoja : TSubsystemCalculoLoja;
  SubsystemHistorico   : TSubsystemHistorico;
  CotacaoDolar         : real;
  ValorVenda           : real;
begin
  // cria as inst�ncias dos Subsystems
  SubsystemCotacaoDolar := TSubsystemCotacaoDolar.Create;
  try
    SubsystemCalculoLoja := TSubsystemCalculoLoja.Create;
    try
      SubsystemHistorico := TSubsystemHistorico.Create;
      try
        // utiliza o primeiro Subsystem para consultar a cota��o do D�lar
        CotacaoDolar := SubsystemCotacaoDolar.ConsultarCotacaoDolar;

        // converte em Reais
        ValorVenda := Preco * CotacaoDolar;

        // utiliza o segundo Subsytem para aplicar desconto e margem de venda
        ValorVenda := SubsystemCalculoLoja.CalcularPrecoFinal (Fidelidade,
          ValorVenda);

        // utiliza o terceiro Subsystem para armazenar o hist�rico do c�lculo
        SubsystemHistorico.RegistrarHistoricoDoCalculo (Fidelidade,
          CotacaoDolar, Preco, ValorVenda);
      finally

        FreeAndNil (SubsystemHistorico);
      end;
    finally
      FreeAndNil (SubsystemCalculoLoja);
    end;
  finally
    // libera as inst�ncias da mem�ria
    FreeAndNil (SubsystemCotacaoDolar);
  end;
end;

end.
