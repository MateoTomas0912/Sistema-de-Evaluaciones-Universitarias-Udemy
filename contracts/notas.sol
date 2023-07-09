// SPDX-License-Identifier: MIT 
pragma solidity >= 0.4.4 <= 0.7.0;
pragma experimental ABIEncoderV2;

contract Notas{
    //variables
    //direccion del profesor que carga las notas
    address public profesor;
    //relaciona el hash del alumno con su nota
    mapping (bytes32 => uint) notas;
    //guarda los alumnos que pidan revisiones de su nota
    string[] revisiones;

    //eventos
    //se emite cuando el alumno es evaluado
    event alumnoEvaluado(bytes32, uint);
    //se emite cuando se solicita una revision de examen
    event pedirRevision(string);

    constructor() {
        //asigno la persona que despliega el contrato como profesor
        profesor = msg.sender;
    }

    //asigna las notas a los alumnos
    function Evaluar(string memory _idAlumno, uint _nota) public UnicamenteProfesor(msg.sender){
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));
        notas[hash_idAlumno] = _nota;
        emit alumnoEvaluado(hash_idAlumno, _nota);
    }

    //pedir revision de un examen
    function Revision(string memory _idAlumno) public {
        revisiones.push(_idAlumno);
        emit pedirRevision(_idAlumno);
    }

    //devuelve la nota asociada al alumno
    function VerNotas(string memory _idAlumno) public view returns(uint){
        return notas[keccak256(abi.encodePacked(_idAlumno))];
    }

    //ver alumnos que solicitaron revision 
    function VerRevisiones() public view UnicamenteProfesor(msg.sender) returns(string[] memory){
        return revisiones;
    }

    //modifiers
    //verifica que solo el profesor (owner) pueda llamar la funcion
    modifier UnicamenteProfesor(address _direccion){
        require(_direccion == msg.sender, "No tienes permiso para ejecutar la funcion");
        _;
    }
}