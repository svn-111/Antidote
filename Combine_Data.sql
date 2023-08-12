-- Accept user input for nid
Clear screen;
SET SERVEROUTPUT ON;
SET VERIFY OFF;
-- Accept user input for nid


-- Search for a user by nid in users_frg1 table
DECLARE
 cnt INTEGER;
 i INTEGER;
BEGIN
	SELECT COUNT(*) INTO cnt FROM users_frg1;
    DBMS_OUTPUT.PUT_LINE('LOCAL');
    -- Search for a user by nid in users_frg1 table
	--DBMS_OUTPUT.PUT_LINE(cnt);
	i:=1;
	WHILE i <= cnt+1 LOOP
		--DBMS_OUTPUT.PUT_LINE(cnt);
		FOR user_row IN (SELECT * FROM users_frg1 WHERE ROWNUM >=i) LOOP
			DBMS_OUTPUT.PUT_LINE('User Info (Fragment 1): ' ||'NID: '|| user_row.nid || ', ' ||'NAME: '|| user_row.name || ', ' ||'CITY: '|| user_row.city);
			FOR user_row1 IN (SELECT * FROM users_frg2 WHERE nid=user_row.nid ) LOOP
			DBMS_OUTPUT.PUT_LINE('User Info (Fragment 2): ' || 'NID: '||user_row1.nid || ', ' ||'VID: '|| user_row1.vid || ', ' ||'CID: '|| user_row1.cid);
			END LOOP;
		END LOOP;
    -- Search for a user by nid in users_frg2 table
		i:=i+1;
	END LOOP;
	DBMS_OUTPUT.PUT_LINE('REMOTE');
	FOR user_row IN (SELECT * FROM users_frg1@SERVER ) LOOP
        DBMS_OUTPUT.PUT_LINE('User Info (Fragment 1): ' ||'NID: '|| user_row.nid || ', ' ||'NAME: '|| user_row.name || ', ' ||'CITY: '|| user_row.city);
    END LOOP;

    -- Search for a user by nid in users_frg2 table
    FOR user_row IN (SELECT * FROM users_frg2@SERVER ) LOOP
        DBMS_OUTPUT.PUT_LINE('User Info (Fragment 2): ' || 'NID: '||user_row.nid || ', ' ||'VID: '|| user_row.vid || ', ' ||'CID: '|| user_row.cid);
    END LOOP;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('User not found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
