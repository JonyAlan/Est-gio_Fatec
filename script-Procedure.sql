
CREATE TABLE [dbo].[TBL_Conflito](
	[codigo] [int] IDENTITY(1,1) NOT NULL,
	[atividade] [int] NOT NULL,
	[atividade2][int] NOT NULL,
	[participante] [int] NOT NULL,

PRIMARY KEY CLUSTERED 
(
	[codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

USE [master]
GO
/****** Object:  StoredProcedure [dbo].[Conflito_ativ]    Script Date: 05/09/2018 08:46:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Conflito_ativ](
	@atividade int,
    @participante1 int
	)
AS
SET NOCOUNT ON
BEGIN
	DECLARE @result as VARCHAR(10) 
	
	DECLARE @dataAtiEn varchar (10)
	DECLARE @horaIniEn TIME
	DECLARE @horaFinEn TIME
	DECLARE @CONT INT = 0

	DECLARE @dataAti varchar (10)
	DECLARE @horaIni TIME
	DECLARE @horaFin TIME
	DECLARE @ativiConfli int
	DECLARE @ativiConfliFin int
	
	DECLARE CursorAtiv CURSOR FOR
		
		SELECT DISTINCT TBL_DATA.dia,TBL_Data.hora_inicio, TBL_Data.hora_termino,TBL_AtividadeParticipante.atividade from TBL_Data , TBL_DataAtividade, TBL_AtividadeParticipante
		where TBL_AtividadeParticipante.participante = @participante1 AND TBL_DataAtividade.atividade <>  @atividade AND TBL_AtividadeParticipante.atividade = TBL_DataAtividade.atividade AND TBL_DataAtividade.data = TBL_Data.codigo ORDER By TBL_DATA.DIA
	 
	OPEN CursorAtiv

	FETCH NEXT FROM CursorAtiv INTO  @dataAti, @horaIni,  @horaFin, @ativiConfli
	WHILE @@FETCH_STATUS = 0
	BEGIN

			DECLARE CursorAtivEn CURSOR FOR
		
			SELECT DISTINCT TBL_DATA.dia,TBL_Data.hora_inicio, TBL_Data.hora_termino from TBL_Data , TBL_DataAtividade, TBL_AtividadeParticipante
			where TBL_DataAtividade.atividade =  @atividade AND TBL_DataAtividade.data = TBL_Data.codigo ORDER By TBL_DATA.DIA
	 
			OPEN CursorAtivEn

			FETCH NEXT FROM CursorAtivEn INTO  @dataAtiEn, @horaIniEn,  @horaFinEn
			WHILE @@FETCH_STATUS = 0
			BEGIN

			IF  @dataAti = @dataAtiEn
			BEGIN	
			   IF ((@horaIniEn  BETWEEN  @horaIni And @horaFin) OR (@horaFinEn  BETWEEN  @horaIni And @horaFin))
				BEGIN
				
				set @CONT = 1
				INSERT INTO dbo.TBL_Conflito(atividade,atividade2,participante) VALUES(@atividade, @ativiConfli, @participante1)
				set @ativiConfliFin =  @ativiConfli

			    END
			END
			
			FETCH NEXT FROM CursorAtivEn INTO  @dataAtiEn, @horaIniEn,  @horaFinEn
			
			END

			CLOSE CursorAtivEn
            DEALLOCATE CursorAtivEn
		

	FETCH NEXT FROM CursorAtiv INTO  @dataAti, @horaIni,  @horaFin,  @ativiConfli
	 
	 END
	 CLOSE CursorAtiv
     DEALLOCATE CursorAtiv
	
	Select @cont, TBL_Atividade.titulo from TBL_Atividade where TBL_Atividade.codigo = @ativiConfliFin

end