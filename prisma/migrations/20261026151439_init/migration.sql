-- CreateEnum
CREATE TYPE "Rol" AS ENUM ('ALUMNO', 'PROFESOR', 'ADMIN');

-- CreateEnum
CREATE TYPE "RolDocente" AS ENUM ('TITULAR', 'SUPLENTE');

-- CreateEnum
CREATE TYPE "MetodoInscripcion" AS ENUM ('CODIGO', 'MANUAL');

-- CreateEnum
CREATE TYPE "DiaSemana" AS ENUM ('LUNES', 'MARTES', 'MIERCOLES', 'JUEVES', 'VIERNES', 'SABADO');

-- CreateEnum
CREATE TYPE "EstadoAsistencia" AS ENUM ('PRESENTE', 'AUSENTE');

-- CreateEnum
CREATE TYPE "AutorMensaje" AS ENUM ('ALUMNO', 'IA');

-- CreateEnum
CREATE TYPE "PresetIA" AS ENUM ('ESTRICTO', 'GUIADO', 'LIBRE_CON_LIMITES');

-- CreateEnum
CREATE TYPE "NivelAyuda" AS ENUM ('BAJO', 'MEDIO', 'ALTO');

-- CreateEnum
CREATE TYPE "SenalamientoError" AS ENUM ('ZONA', 'SINTOMA');

-- CreateTable
CREATE TABLE "usuario" (
    "id_usuario" SERIAL NOT NULL,
    "email" TEXT NOT NULL,
    "password_hash" TEXT NOT NULL,
    "rol" "Rol" NOT NULL,
    "activo" BOOLEAN NOT NULL DEFAULT true,
    "creado_en" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "usuario_pkey" PRIMARY KEY ("id_usuario")
);

-- CreateTable
CREATE TABLE "alumno" (
    "id_alumno" SERIAL NOT NULL,
    "dni" TEXT NOT NULL,
    "nombre" TEXT NOT NULL,
    "apellido" TEXT NOT NULL,
    "telefono" TEXT,
    "fecha_nacimiento" DATE NOT NULL,
    "id_usuario" INTEGER NOT NULL,

    CONSTRAINT "alumno_pkey" PRIMARY KEY ("id_alumno")
);

-- CreateTable
CREATE TABLE "profesor" (
    "id_profesor" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,
    "apellido" TEXT NOT NULL,
    "direccion" TEXT,
    "cuil" TEXT NOT NULL,
    "telefono" TEXT,
    "antiguedad" INTEGER,
    "id_usuario" INTEGER NOT NULL,

    CONSTRAINT "profesor_pkey" PRIMARY KEY ("id_profesor")
);

-- CreateTable
CREATE TABLE "materia" (
    "id_materia" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,
    "cod_invitacion" TEXT NOT NULL,

    CONSTRAINT "materia_pkey" PRIMARY KEY ("id_materia")
);

-- CreateTable
CREATE TABLE "modulo" (
    "id_modulo" SERIAL NOT NULL,
    "dia" "DiaSemana" NOT NULL,
    "hora_inicio" TEXT NOT NULL,
    "hora_fin" TEXT NOT NULL,
    "id_materia" INTEGER NOT NULL,

    CONSTRAINT "modulo_pkey" PRIMARY KEY ("id_modulo")
);

-- CreateTable
CREATE TABLE "inscripcion" (
    "id_inscripcion" SERIAL NOT NULL,
    "fecha_insc" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "metodo" "MetodoInscripcion" NOT NULL,
    "id_alumno" INTEGER NOT NULL,
    "id_materia" INTEGER NOT NULL,

    CONSTRAINT "inscripcion_pkey" PRIMARY KEY ("id_inscripcion")
);

-- CreateTable
CREATE TABLE "asignacion_docente" (
    "id_asignacion" SERIAL NOT NULL,
    "rol" "RolDocente" NOT NULL,
    "fecha_inicio" DATE NOT NULL,
    "fecha_fin" DATE,
    "id_profesor" INTEGER NOT NULL,
    "id_materia" INTEGER NOT NULL,

    CONSTRAINT "asignacion_docente_pkey" PRIMARY KEY ("id_asignacion")
);

-- CreateTable
CREATE TABLE "tarea" (
    "id_tarea" SERIAL NOT NULL,
    "titulo" TEXT NOT NULL,
    "consigna" TEXT NOT NULL,
    "requiere_entrega" BOOLEAN NOT NULL DEFAULT true,
    "fecha_publicacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fecha_limite" TIMESTAMP(3),
    "id_materia" INTEGER NOT NULL,
    "id_profesor" INTEGER NOT NULL,

    CONSTRAINT "tarea_pkey" PRIMARY KEY ("id_tarea")
);

-- CreateTable
CREATE TABLE "nota" (
    "id_nota" SERIAL NOT NULL,
    "valor" DECIMAL(4,2),
    "comentario" TEXT,
    "publica" BOOLEAN NOT NULL DEFAULT false,
    "fecha" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id_tarea" INTEGER NOT NULL,
    "id_alumno" INTEGER NOT NULL,

    CONSTRAINT "nota_pkey" PRIMARY KEY ("id_nota")
);

-- CreateTable
CREATE TABLE "entrega" (
    "id_entrega" SERIAL NOT NULL,
    "archivo_url" TEXT,
    "texto" TEXT,
    "link" TEXT,
    "fecha_entrega" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id_tarea" INTEGER NOT NULL,
    "id_alumno" INTEGER NOT NULL,

    CONSTRAINT "entrega_pkey" PRIMARY KEY ("id_entrega")
);

-- CreateTable
CREATE TABLE "asistencia" (
    "id_asistencia" SERIAL NOT NULL,
    "estado" "EstadoAsistencia" NOT NULL,
    "fecha" DATE NOT NULL,
    "id_alumno" INTEGER NOT NULL,
    "id_materia" INTEGER NOT NULL,

    CONSTRAINT "asistencia_pkey" PRIMARY KEY ("id_asistencia")
);

-- CreateTable
CREATE TABLE "chat" (
    "id_chat" SERIAL NOT NULL,
    "creado_en" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id_alumno" INTEGER NOT NULL,
    "id_materia" INTEGER NOT NULL,
    "id_tarea" INTEGER,

    CONSTRAINT "chat_pkey" PRIMARY KEY ("id_chat")
);

-- CreateTable
CREATE TABLE "mensaje" (
    "id_mensaje" SERIAL NOT NULL,
    "autor" "AutorMensaje" NOT NULL,
    "contenido" TEXT NOT NULL,
    "fecha" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id_chat" INTEGER NOT NULL,

    CONSTRAINT "mensaje_pkey" PRIMARY KEY ("id_mensaje")
);

-- CreateTable
CREATE TABLE "configuracion_ia" (
    "id_configuracion" SERIAL NOT NULL,
    "preset" "PresetIA" NOT NULL,
    "nivel_ayuda" "NivelAyuda" NOT NULL,
    "permite_codigo" BOOLEAN NOT NULL DEFAULT false,
    "senala_error" "SenalamientoError" NOT NULL DEFAULT 'SINTOMA',
    "permite_recursos_externos" BOOLEAN NOT NULL DEFAULT false,
    "limite_pistas" INTEGER,
    "id_materia" INTEGER NOT NULL,
    "id_tarea" INTEGER,
    "id_profesor" INTEGER NOT NULL,

    CONSTRAINT "configuracion_ia_pkey" PRIMARY KEY ("id_configuracion")
);

-- CreateIndex
CREATE UNIQUE INDEX "usuario_email_key" ON "usuario"("email");

-- CreateIndex
CREATE UNIQUE INDEX "alumno_dni_key" ON "alumno"("dni");

-- CreateIndex
CREATE UNIQUE INDEX "alumno_id_usuario_key" ON "alumno"("id_usuario");

-- CreateIndex
CREATE UNIQUE INDEX "profesor_cuil_key" ON "profesor"("cuil");

-- CreateIndex
CREATE UNIQUE INDEX "profesor_id_usuario_key" ON "profesor"("id_usuario");

-- CreateIndex
CREATE UNIQUE INDEX "materia_cod_invitacion_key" ON "materia"("cod_invitacion");

-- CreateIndex
CREATE UNIQUE INDEX "inscripcion_id_alumno_id_materia_key" ON "inscripcion"("id_alumno", "id_materia");

-- CreateIndex
CREATE UNIQUE INDEX "nota_id_tarea_id_alumno_key" ON "nota"("id_tarea", "id_alumno");

-- CreateIndex
CREATE UNIQUE INDEX "entrega_id_tarea_id_alumno_key" ON "entrega"("id_tarea", "id_alumno");

-- CreateIndex
CREATE UNIQUE INDEX "asistencia_id_alumno_id_materia_fecha_key" ON "asistencia"("id_alumno", "id_materia", "fecha");

-- AddForeignKey
ALTER TABLE "alumno" ADD CONSTRAINT "alumno_id_usuario_fkey" FOREIGN KEY ("id_usuario") REFERENCES "usuario"("id_usuario") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "profesor" ADD CONSTRAINT "profesor_id_usuario_fkey" FOREIGN KEY ("id_usuario") REFERENCES "usuario"("id_usuario") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "modulo" ADD CONSTRAINT "modulo_id_materia_fkey" FOREIGN KEY ("id_materia") REFERENCES "materia"("id_materia") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "inscripcion" ADD CONSTRAINT "inscripcion_id_alumno_fkey" FOREIGN KEY ("id_alumno") REFERENCES "alumno"("id_alumno") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "inscripcion" ADD CONSTRAINT "inscripcion_id_materia_fkey" FOREIGN KEY ("id_materia") REFERENCES "materia"("id_materia") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "asignacion_docente" ADD CONSTRAINT "asignacion_docente_id_profesor_fkey" FOREIGN KEY ("id_profesor") REFERENCES "profesor"("id_profesor") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "asignacion_docente" ADD CONSTRAINT "asignacion_docente_id_materia_fkey" FOREIGN KEY ("id_materia") REFERENCES "materia"("id_materia") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tarea" ADD CONSTRAINT "tarea_id_materia_fkey" FOREIGN KEY ("id_materia") REFERENCES "materia"("id_materia") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tarea" ADD CONSTRAINT "tarea_id_profesor_fkey" FOREIGN KEY ("id_profesor") REFERENCES "profesor"("id_profesor") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "nota" ADD CONSTRAINT "nota_id_tarea_fkey" FOREIGN KEY ("id_tarea") REFERENCES "tarea"("id_tarea") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "nota" ADD CONSTRAINT "nota_id_alumno_fkey" FOREIGN KEY ("id_alumno") REFERENCES "alumno"("id_alumno") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "entrega" ADD CONSTRAINT "entrega_id_tarea_fkey" FOREIGN KEY ("id_tarea") REFERENCES "tarea"("id_tarea") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "entrega" ADD CONSTRAINT "entrega_id_alumno_fkey" FOREIGN KEY ("id_alumno") REFERENCES "alumno"("id_alumno") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "asistencia" ADD CONSTRAINT "asistencia_id_alumno_fkey" FOREIGN KEY ("id_alumno") REFERENCES "alumno"("id_alumno") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "asistencia" ADD CONSTRAINT "asistencia_id_materia_fkey" FOREIGN KEY ("id_materia") REFERENCES "materia"("id_materia") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "chat" ADD CONSTRAINT "chat_id_alumno_fkey" FOREIGN KEY ("id_alumno") REFERENCES "alumno"("id_alumno") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "chat" ADD CONSTRAINT "chat_id_materia_fkey" FOREIGN KEY ("id_materia") REFERENCES "materia"("id_materia") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "chat" ADD CONSTRAINT "chat_id_tarea_fkey" FOREIGN KEY ("id_tarea") REFERENCES "tarea"("id_tarea") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mensaje" ADD CONSTRAINT "mensaje_id_chat_fkey" FOREIGN KEY ("id_chat") REFERENCES "chat"("id_chat") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "configuracion_ia" ADD CONSTRAINT "configuracion_ia_id_materia_fkey" FOREIGN KEY ("id_materia") REFERENCES "materia"("id_materia") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "configuracion_ia" ADD CONSTRAINT "configuracion_ia_id_tarea_fkey" FOREIGN KEY ("id_tarea") REFERENCES "tarea"("id_tarea") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "configuracion_ia" ADD CONSTRAINT "configuracion_ia_id_profesor_fkey" FOREIGN KEY ("id_profesor") REFERENCES "profesor"("id_profesor") ON DELETE RESTRICT ON UPDATE CASCADE;
