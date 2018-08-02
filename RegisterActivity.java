package com.selahattin.mobilkartvizit;

import android.content.Intent;
import android.graphics.Typeface;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v7.app.AppCompatActivity;
import android.util.Patterns;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthUserCollisionException;


public class RegisterActivity extends AppCompatActivity implements View.OnClickListener{

    private FirebaseAuth mAuth;
    
    ProgressBar progressBar;
    EditText registerEmailText;
    EditText registerPasswordText;
    Button registerSignUpButton;
    TextView registerSignInTextView;
    String email;
    String password;



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.register_activity);

        registerEmailText= (EditText) findViewById(R.id.emailRegisterText);
        registerPasswordText = (EditText) findViewById(R.id.passwordRegisterText);
        registerSignUpButton = (Button) findViewById(R.id.signUpButton);
        registerSignInTextView = (TextView)findViewById(R.id.signInTextView);
        progressBar =(ProgressBar)findViewById(R.id.progressbar);

        mAuth = FirebaseAuth.getInstance();
        findViewById(R.id.signUpButton).setOnClickListener(this);

        TextView businessCard = (TextView) findViewById(R.id.businessCard);
        Typeface typeface = Typeface.createFromAsset(getAssets(), "fonts/bellada.ttf");
        businessCard.setTypeface(typeface);





    }
    private void registerUser(){
        email = registerEmailText.getText().toString().trim();
        password =registerPasswordText.getText().toString().trim();

        if (email.isEmpty()){
            registerEmailText.setError("Email is required");                                         //Email necessary.
            registerEmailText.requestFocus();
            return;
        }

        if (!Patterns.EMAIL_ADDRESS.matcher(email).matches()){                                       //fill a valid email 
            registerEmailText.setError("Please enter a valid email ");
            registerEmailText.requestFocus();
            return;
        }

        if (password.isEmpty()){
            registerPasswordText.setError("Password is required");                                   //fill password.
            registerPasswordText.requestFocus();
            return;
        }

        if (password.length()<6){                                                                    //Mimimum 6 length password.
            registerPasswordText.setError("Minimum length of password should be 6");
            registerPasswordText.requestFocus();
            return;
        }

        progressBar.setVisibility(View.VISIBLE);


        mAuth.createUserWithEmailAndPassword(email,password).addOnCompleteListener(new OnCompleteListener<AuthResult>() {
            @Override
            public void onComplete(@NonNull Task<AuthResult> task) {
                progressBar.setVisibility(View.GONE);
                if (task.isSuccessful()){                                                            //user saved successfully
                    Intent intent =new Intent(RegisterActivity.this,ProfileActivity.class);
                    intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                    startActivity(intent);
                } else{

                    if (task.getException() instanceof FirebaseAuthUserCollisionException){
                        Toast.makeText(getApplicationContext(),"You are already registered", Toast.LENGTH_SHORT).show();
                    } else {
                        Toast.makeText(getApplicationContext(), task.getException().getMessage(), Toast.LENGTH_SHORT).show();
                    }
                }
            }
        });
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()){
            case R.id.signUpButton:
                registerUser();
                break;
            case R.id.signInTextView:
                startActivity(new Intent(this,LoginActivity.class));

                break;
        }

    }

}