package ubd;

public class TitleID {
	private int noteId;
	private String noteTitle;
	TitleID(int noteId,String noteTitle) {
		this.noteId = noteId;
		this.noteTitle = noteTitle;
	}
	public int getNoteId() {
		return noteId;
	}
	public String getNoteTitle() {
		return noteTitle;
	}
		
}